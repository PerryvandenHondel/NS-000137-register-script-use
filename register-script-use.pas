{ =====================================================================================================================

	PROGRAM:
		register-script-use.exe

	DESCRIPTION:
		Register the use of a script.
		
			
  
	VERSION:
		01	2015-04-23	PVDH	Initial version

	RETURNS:
		Nothing
	
	FUNCTIONS AND PROCEDURES:
		function ConvertFile
		function GetEventType
		function GetKeyName
		function GetKeyType
		function ProcessThisEvent
		procedure EventDetailReadConfig
		procedure EventDetailRecordAdd
		procedure EventDetailRecordShow
		procedure EventFoundAdd
		procedure EventFoundStats
		procedure EventIncreaseCount
		procedure EventReadConfig
		procedure EventRecordAdd
		procedure EventRecordShow
		procedure ProcessEvent
		procedure ProcessLine
		procedure ProgramDone
		procedure ProgramInit
		procedure ProgramRun
		procedure ProgramTest
		procedure ProgramTitle
		procedure ProgramUsage
		procedure ShowStatistics
		
	
 =====================================================================================================================} 


program RegisterScriptUse;


{$mode objfpc}
{$H+}


uses
	Classes, 
	DateUtils,
	DOS,
	StrUtils,
	Sysutils,
	UTextFile,
	USplunkFile,
	USupportLibrary;

	
var
	tfLog: CTextFile;
	pathLog: string;
	line: string;
	scriptId: string;
	

function GetYearMonthFs(): string;
{
	Returns the current year and month in file system allowed format: YYYYMmm
} 
var
	year: word;
	month: word;
	mday: word;
	wday: word;
begin
	GetDate(year, month, mday, wday);
	GetYearMonthFs := IntToStr(year) + 'M' + NumberAlign(month, 2);
	// + NumberAlign(mday, 2);
end; // of function GetYearMonthFs

	
procedure ProgramUsage();
begin
	WriteLn();
	WriteLn('Usage:');
	WriteLn(Chr(9) + ParamStr(0) + ' [script-id]');
	WriteLn();
	WriteLn('Options:');
	WriteLn(Chr(9) + '[script-id]       ID of the script to register');
	WriteLn();
	WriteLn('Example:');
	WriteLn(Chr(9) + ParamStr(0) + ' 12');
	WriteLn();
end; // of procedure ProgramUsage()	
	
	
begin
	if ParamCount = 0 then
	begin
		ProgramUsage();
		Halt(0);
	end
	else
	begin
		scriptId := ParamStr(1);

		pathLog := '\\vm70as006.rec.nsint\000137-EXPORT\' + GetYearMonthFs() + '.csv';
	
		WriteLn('Writing to: ' + pathLog);
			
		tfLog := CTextFile.Create(pathLog);
		tfLog.OpenFileWrite();	

		line := GetProperDateTime(Now()) + ';' + GetCurrentUserName() + ';' + scriptId;
	
		tfLog.WriteToFile(line);
	
		tfLog.CloseFile();
	end;
end. // of program RegisterScriptUse