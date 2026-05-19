void M_DetermineTimes()
{
   stGVL.GMTTime    = TimeGMT();
   stGVL.dtCurrentTime = TimeCurrent();
   stGVL.dtTimeLast_CurrTF = iTime(_Symbol, PERIOD_CURRENT, 0);
   
   M_ChangeLabelText("GMTTime", "GMT time " + TimeToString(stGVL.GMTTime,TIME_SECONDS));
   M_ChangeLabelText("ServerTime", "Server time " + TimeToString(stGVL.dtCurrentTime,TIME_SECONDS));
   
}