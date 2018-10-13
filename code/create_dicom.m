
function create_dicom(X, FILENAME, Sp, Sz, F, STUDYUID, SERIESUID, DATETIME)

% CREATE_DICOM Create DICOM format output file from data
%
%  CREATE_DICOM(X, FILENAME, Sp) creates a new DICOM file with a
%  name `FILENAME_0001.dcm' and containing data from X. The pixel scale is
%  given by Sp which is in mm.
%
%  CREATE_DICOM(X, FILENAME, Sp, Sz, F) creates a new DICOM file with a
%  name formed from the given FILENAME and the frame number F, and
%  containing data from X. The pixel scale is given by Sp, and the frame
%  spacing is given by Sz, both of which are in mm.
%
%  CREATE_DICOM(X, FILENAME, Sp, Sz, F, STUDYUID, SERIESUID, DATETIME)
%  uses the DICOM UIDs STUDYUID and SERIESUID, and also the
%  time and date DATETIME, for the file. This is useful if you want to write several
%  frames in the same DICOM series. The UIDs can be generated
%  using the DICOMUID function. The DATETIME can be generated using now().

% check for inputs
narginchk(3,8);
nargoutchk(0,0);
if (nargin<8)
  DATETIME = now();
end
if (nargin<7)
  STUDYUID = dicomuid();
  SERIESUID = dicomuid();
end
if (nargin<5)
  F = 1;
end
if (nargin<4)
  Sz = Sp;
end

% get data with the appropriate limits
X = X+1024;
X(X<0) = 0;
X(X>4096) = 4096;

% Initial write to create DICOM file with default settings
file = sprintf('%s_%04i.dcm', FILENAME, F);
dicomwrite(uint16(X), file, 'ObjectType', 'CT Image Storage');

% read back and correct metadata
SERIESDATE = datestr(DATETIME, 'yyyymmdd');
SERIESTIME = datestr(DATETIME, 'HHMMSS');
metadata = dicominfo(file);
metadata.StudyInstanceUID = STUDYUID;
metadata.SeriesInstanceUID = SERIESUID;
metadata.StudyDescription = [FILENAME ' Study'];
metadata.SeriesDescription = [FILENAME ' Series'];
metadata.StudyID = '1';
metadata.SeriesNumber = 1;
metadata.StudyDate = SERIESDATE;
metadata.SeriesDate = SERIESDATE;
metadata.AcquisitionDate = SERIESDATE;
metadata.ContentDate = SERIESDATE;
metadata.StudyTime = SERIESTIME;
metadata.SeriesTime = SERIESTIME;
metadata.AcquisitionTime = SERIESTIME;
metadata.ContentTime = SERIESTIME;
metadata.PatientName = STUDYUID;
metadata.Modality = 'CT';
metadata.RescaleIntercept = '-1024';
metadata.RescaleSlope = '1';
metadata.RescaleType = 'HU';
metadata.WindowWidth = '2000';
metadata.WindowCenter = '0';
metadata.ImagePositionPatient = double([0.000 0.000 F*Sz]);
metadata.ImageOrientationPatient = double([1.000 0.000 0.000 0.000 1.000 0.000]);
metadata.SpacingBetweenSlices = num2str(Sz);
metadata.SliceThickness = num2str(Sz);
metadata.GantryDetectorTilt = '0';
metadata.SliceLocation = num2str(F*Sz);
metadata.PixelSpacing = [Sp Sp];

% write final file with this metadata
dicomwrite(uint16(X), file, metadata, 'CreateMode', 'copy');
