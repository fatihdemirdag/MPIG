unit MainUnit;


interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Colors, FMX.ListBox, FMX.Edit,
  FMX.EditBox, FMX.SpinBox;


type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    txtFileName: TLabel;
    lblFileName: TLabel;
    txtImageSize: TLabel;
    lblImageSize: TLabel;
    tabcImages: TTabControl;
    tabiResult: TTabItem;
    tabiOriginal: TTabItem;
    imgvOriginal: TImageViewer;
    imgvFinal: TImageViewer;
    cbxBackgroundType: TComboBox;
    txtBackgroundType: TLabel;
    clrbBackgroundColor: TComboColorBox;
    txtBackgroundColor: TLabel;
    txtScale: TLabel;
    spnScale: TSpinBox;
    MainMenu1: TMainMenu;
    mmiFile: TMenuItem;
    mmiLoad: TMenuItem;
    mmiExport: TMenuItem;
    mmiQuit: TMenuItem;
    ProgressBar1: TProgressBar;
    txtProgress: TLabel;
    SaveDialog1: TSaveDialog;
    procedure mmiLoadClick(Sender: TObject);
    procedure spnScaleChange(Sender: TObject);
    procedure clrbBackgroundColorChange(Sender: TObject);
    procedure cbxBackgroundTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mmiQuitClick(Sender: TObject);
    procedure mmiExportClick(Sender: TObject);

  private
    procedure UpdateImage;
    function ScaleIconDown(bmp: TBitmap; size: integer): TBitmap;
    procedure ExportIconWithSize(bmp: TBitmap; size: integer; fileName: string);

  public
    { Public declarations }
  end;


var
  Form1: TForm1;


implementation


{$R *.fmx}



procedure TForm1.cbxBackgroundTypeChange(Sender: TObject);
begin
  UpdateImage;
end;



procedure TForm1.clrbBackgroundColorChange(Sender: TObject);
begin
  UpdateImage;
end;



procedure TForm1.ExportIconWithSize(bmp: TBitmap; size: integer; fileName: string);
var
  tmp: TBitmap;
begin
  tmp := TBitmap.Create(size, size);
  tmp.Canvas.BeginScene();
  tmp.Canvas.DrawBitmap(bmp, bmp.BoundsF, tmp.BoundsF, 1.0, false);
  tmp.Canvas.EndScene;
  tmp.SaveToFile(fileName);
  tmp.Free;

  ProgressBar1.Value := ProgressBar1.Value + 1.0;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin
  imgvFinal.Bitmap      := TBitmap.Create(1024, 1024);
  imgvFinal.BitmapScale := imgvFinal.Width / 1024.0;
end;



procedure TForm1.mmiExportClick(Sender: TObject);
var
  path: string;
  img768, img512, img384, img256, img192, img128, img96, img64, img48, img32: TBitmap;
begin
  if SaveDialog1.Execute then
  begin
    path := ExtractFilePath(SaveDialog1.fileName);

    System.IOUtils.TDirectory.CreateDirectory(path + '\android\');
    System.IOUtils.TDirectory.CreateDirectory(path + '\ios\');
    System.IOUtils.TDirectory.CreateDirectory(path + '\ios\iphone\');
    System.IOUtils.TDirectory.CreateDirectory(path + '\ios\ipad\');

    img768 := ScaleIconDown(imgvFinal.Bitmap, 768);
    img512 := ScaleIconDown(img768, 512);
    img384 := ScaleIconDown(img512, 384);
    img256 := ScaleIconDown(img384, 256);
    img192 := ScaleIconDown(img256, 192);
    img128 := ScaleIconDown(img192, 128);
    img96 := ScaleIconDown(img128, 96);
    img64 := ScaleIconDown(img96, 64);
    img48 := ScaleIconDown(img64, 48);
    img32 := ScaleIconDown(img48, 32);

    ProgressBar1.Value := 0;
    ExportIconWithSize(img48, 36, path + '\android\launcher_36_ldpi.png');
    ExportIconWithSize(img48, 48, path + '\android\launcher_48_mdpi.png');
    ExportIconWithSize(img96, 72, path + '\android\launcher_72_hdpi.png');
    ExportIconWithSize(img96, 96, path + '\android\launcher_96_xhdpi.png');
    ExportIconWithSize(img192, 144, path + '\android\launcher_144_xxhdpi.png');
    ExportIconWithSize(img192, 192, path + '\android\launcher_192_xxxhdpi.png');
    ExportIconWithSize(img32, 24, path + '\android\notification_24_mdpi.png');
    ExportIconWithSize(img48, 36, path + '\android\notification_36_hdpi.png');
    ExportIconWithSize(img48, 48, path + '\android\notification_48_xhdpi.png');
    ExportIconWithSize(img96, 72, path + '\android\notification_72_xxhdpi.png');
    ExportIconWithSize(img96, 96, path + '\android\notification_96_xxxhdpi.png');

    ExportIconWithSize(img128, 120, path + '\ios\iphone\ApplicationIcon_120.png');
    ExportIconWithSize(img192, 180, path + '\ios\iphone\ApplicationIcon_180.png');
    ExportIconWithSize(imgvFinal.Bitmap, 1024, path + '\ios\iphone\ApplicationIcon_1024.png');
    ExportIconWithSize(img96, 80, path + '\ios\iphone\SpotlightSearchIcon_80.png');
    ExportIconWithSize(img128, 120, path + '\ios\iphone\SpotlightSearchIcon_120.png');
    ExportIconWithSize(img64, 58, path + '\ios\iphone\SettingIcon_58.png');
    ExportIconWithSize(img96, 87, path + '\ios\iphone\SettingIcon_87.png');
    ExportIconWithSize(img48, 40, path + '\ios\iphone\NotificationIcon_40.png');
    ExportIconWithSize(img64, 60, path + '\ios\iphone\NotificationIcon_60.png');
    ExportIconWithSize(img512, 459, path + '\ios\iphone\LaunchImage_2x.png');
    ExportIconWithSize(img768, 688, path + '\ios\iphone\LaunchImage_3x.png');
    ExportIconWithSize(img512, 459, path + '\ios\iphone\LaunchImage_2x_dark.png');
    ExportIconWithSize(img768, 688, path + '\ios\iphone\LaunchImage_3x_dark.png');

    ExportIconWithSize(img192, 152, path + '\ios\ipad\ApplicationIcon_152.png');
    ExportIconWithSize(img192, 167, path + '\ios\ipad\ApplicationIcon_167.png');
    ExportIconWithSize(img96, 80, path + '\ios\ipad\SpotlightSearchIcon_80.png');
    ExportIconWithSize(img64, 58, path + '\ios\ipad\SettingIcon_58.png');
    ExportIconWithSize(img48, 40, path + '\ios\iphone\NotificationIcon_40.png');
    ExportIconWithSize(imgvFinal.Bitmap, 965, path + '\ios\iphone\LaunchImage.png');
    ExportIconWithSize(imgvFinal.Bitmap, 965, path + '\ios\iphone\LaunchImage_dark.png');
  end;
end;



procedure TForm1.mmiLoadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    imgvOriginal.Bitmap.LoadFromFile(OpenDialog1.fileName);
    imgvOriginal.BestFit;
    imgvOriginal.BackgroundFill := TBrush.Create(TBrushKind.None, $00000000);

    lblFileName.Text  := OpenDialog1.fileName;
    lblImageSize.Text := IntToStr(imgvOriginal.Bitmap.Width) + ' x ' + IntToStr(imgvOriginal.Bitmap.Height);
  end;
end;



procedure TForm1.mmiQuitClick(Sender: TObject);
begin
  Exit;
end;



function TForm1.ScaleIconDown(bmp: TBitmap; size: integer): TBitmap;
begin
  result := TBitmap.Create(size, size);
  result.Canvas.BeginScene();
  result.Canvas.DrawBitmap(bmp, bmp.BoundsF, result.BoundsF, 1.0, false);
  result.Canvas.EndScene;
end;

procedure TForm1.spnScaleChange(Sender: TObject);
begin
  UpdateImage;
end;



procedure TForm1.UpdateImage;
var
  tmpbmp, tmpmask: TBitmap;
begin
  tmpbmp  := TBitmap.Create(1024, 1024);
  tmpmask := TBitmap.Create(1024, 1024);

  tmpbmp.Canvas.BeginScene();
  tmpbmp.Canvas.Clear($00000000);

  tmpbmp.Canvas.FillRect(TRectF.Create(8.0, 8.0, 1008.0, 1008.0), 1.0,
    TBrush.Create(TBrushKind.Solid, clrbBackgroundColor.Color));

  tmpbmp.Canvas.DrawBitmap(imgvOriginal.Bitmap, imgvOriginal.Bitmap.BoundsF,
    TRectF.Create(512.0 - 480.0 * (spnScale.Value / 100.0), 512.0 - 480.0 * (spnScale.Value / 100.0),
    512.0 + 480.0 * (spnScale.Value / 100.0), 512.0 + 480.0 * (spnScale.Value / 100.0)), 1.0);
  tmpbmp.Canvas.EndScene;

  // mask
  tmpmask.Canvas.BeginScene();
  tmpmask.Canvas.Clear($FF000000);
  if cbxBackgroundType.ItemIndex = 0 then
  begin
    tmpmask.Canvas.FillRect(TRectF.Create(8.0, 8.0, 1008.0, 1008.0), 1.0, TBrush.Create(TBrushKind.Solid, $FFFFFFFF));
  end
  else if cbxBackgroundType.ItemIndex = 1 then
  begin
    tmpmask.Canvas.FillRect(TRectF.Create(8.0, 8.0, 1008.0, 1008.0), 96.0, 96.0,
      [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1.0,
      TBrush.Create(TBrushKind.Solid, $FFFFFFFF));
  end
  else if cbxBackgroundType.ItemIndex = 2 then
  begin
    tmpmask.Canvas.FillRect(TRectF.Create(8.0, 8.0, 1008.0, 1008.0), 192.0, 192.0,
      [TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1.0,
      TBrush.Create(TBrushKind.Solid, $FFFFFFFF));
  end
  else if cbxBackgroundType.ItemIndex = 3 then
  begin
    tmpmask.Canvas.FillEllipse(TRectF.Create(8.0, 8.0, 1008.0, 1008.0), 1.0,
      TBrush.Create(TBrushKind.Solid, $FFFFFFFF));
  end;
  tmpmask.Canvas.EndScene;

  if imgvFinal.Bitmap <> nil then
    imgvFinal.Bitmap := nil;

  imgvFinal.Bitmap := imgvFinal.Bitmap.CreateFromBitmapAndMask(tmpbmp, tmpmask);
end;


end.
