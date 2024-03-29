Attribute VB_Name = "ScreenCopy"
'スクリーンのスナップショットをクリップボードに保存及び印刷　　変数宣言部　　（273） '

Private Declare Sub keybd_event Lib "user32.dll" _
        (ByVal bVk As Byte, ByVal bScan As Byte, _
         ByVal dwFlags As Long, ByVal dwExtraInfo As Long)

Private Const VK_SNAPSHOT = &H2C            'PrintScreen キー(P1051)
Private Const VK_LMENU = &HA4               'Altキー
Private Const KEYEVENTF_KEYUP = &H2         'キーはアップ状態
Private Const KEYEVENTF_EXTENDEDKEY = &H1   'スキャンコードは拡張コード



'スクリーンのスナップショットをクリップボードに保存及び印刷　本体　　　　　（273） '

Private Sub SaveWindowPic(Optional ActWind As Boolean = True, _
                                    Optional PrintOn As Boolean = False)
'スクリーンのスナップショットをクリップボードに保存及び印刷　　　　　　　　　（273） '
'フォームにCommandボタンを２個貼り付けておいて下さい。
'　 Option Explicit　　 'SampleNo=273　WindowsXP VB6.0(SP5) 2003.03.30
'キーストロークをシミュレートする(P1065)

    Dim MyFileName As String, PicData As Picture, OsVer As Single
    Dim sngSt As Single
'
    Clipboard.Clear
    OsVer = CreateObject("SysInfo.SYSINFO").OSVersion

    If ActWind Then
    'アクティブ ウィンドウのスナップショットを取得する
    '以下の２方法どれでもOK(Win98SE/WinXP/Win95）
    'どの方法でも上記確認機種は同じ動作しますのでMSのサンプルの方法を使用
        Call keybd_event(VK_LMENU, &H56, _
                                KEYEVENTF_EXTENDEDKEY Or 0, 0)
        Call keybd_event(VK_SNAPSHOT, &H79, _
                                KEYEVENTF_EXTENDEDKEY Or 0, 0)
        Call keybd_event(VK_SNAPSHOT, &H79, _
                                KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, 0)
        Call keybd_event(VK_LMENU, &H56, _
                                KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, 0)
'　　　　==================== こちらでも同じようです ==================
'　　　　Call keybd_event(VK_LMENU, 0, _
　　　　　　　　　　　　　　　　KEYEVENTF_EXTENDEDKEY Or 0, 0)
'　　　　Call keybd_event(VK_SNAPSHOT, 0, _
　　　　　　　　　　　　　　　　KEYEVENTF_EXTENDEDKEY Or 0, 0)
'　　　　Call keybd_event(VK_SNAPSHOT, 0, _
　　　　　　　　　　　KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, 0)
'　　　　Call keybd_event(VK_LMENU, 0, _
　　　　　　　　　　　KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, 0)
    ElseIf ActWind = False And OsVer < 5 Then
    '画面全体のスナップショットを取得する(Win98SE/Win95)
        Call keybd_event(VK_SNAPSHOT, 1, KEYEVENTF_EXTENDEDKEY, 0)
        Call keybd_event(VK_SNAPSHOT, 1, KEYEVENTF_EXTENDEDKEY Or _
                                                                          KEYEVENTF_KEYUP, 0)
    Else
    '画面全体のスナップショットを取得する(WinXP)
        Call keybd_event(VK_SNAPSHOT, 0, KEYEVENTF_EXTENDEDKEY, 0)
        Call keybd_event(VK_SNAPSHOT, 0, KEYEVENTF_EXTENDEDKEY Or _
                                                                          KEYEVENTF_KEYUP, 0)
    End If

    sngSt = Timer                           ' Windows7 には、この遅延Loopが必要
    Do While Timer - sngSt < 0.5
       DoEvents
    Loop
    'クリップボード内にビットマップ形式のデータがあるか調べる
    If Clipboard.GetFormat(vbCFBitmap) Then
        'ファイル名を自動生成
        MyFileName = App.path & "\" & gcoxFlName$ & Format$(Now, "yymmddhhmmss") & ".BMP"
        '表示データーをビットマップ形式のデータで保存
        Set PicData = Clipboard.GetData
        Call SavePicture(PicData, MyFileName)
        If PrintOn Then
            '印刷する場合
            With Printer
                .ScaleMode = vbMillimeters
                .PaperSize = vbPRPSA4
                .Orientation = vbPRORLandscape
                .PaintPicture PicData, 10, 0
                .EndDoc
            End With
        End If
    Else
        MsgBox "保存出来ませんでした。"
    End If
End Sub
'
'
'
'Private Sub Command1_Click()
''アクティブウインドウのみをクリップボードにコピー
'    Call SaveWindowPic(True, False)     '印刷する場合は　True に設定
'End Sub
'
'Private Sub Command2_Click()
''スクリーン全体をクリップボードにコピー
'    Call SaveWindowPic(False, False)
'End Sub




NQD　Vbの場合
＜NQD70_SC＞へ追加
フラグの追加　　冒頭の宣言部
Dim iflgSCopy As Boolean   ' ScreenCopy フラグ

＜コマンドボタンの追加＞
Private Sub Command3_Click()
'''アクティブウインドウをクリップボードにコピー印刷する。　True に設定
  If iflgSCopy = True Then
          iflgSCopy = False          'ScreenCopy　受付解除
          Command3.BackColor = CmndColoff(0)
    Else
          iflgSCopy = True      'ScreenCopy　受付
          Command3.BackColor = CmndColon(1)    ' on 1=red
  End If
End Sub

<NQD70_SCの本体への　call文追加＞
>'/* データの保存　*/
>      If lDtSaveFlg = True Then
>        ResDtSave i_s, stime
>        lDtSaveFlg = False
>      End If
'
' ScreenCopy iflgSCopy=True の場合、ScreenCopy
    If iflgSCopy = True Then
        Call SaveWindowPic(True, False)     'Active Windowの保存
    End If
    iflgSCopy = False          'ScreenCopy　受付解除
    Command3.BackColor = CmndColoff(0)
'

