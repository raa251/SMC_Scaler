void M_DetermineTimes()
{
   stGVL.GMTTime    = TimeGMT();
   stGVL.dtCurrentTime = TimeCurrent();
   stGVL.dtTimeCurrent_CurrTF = iTime(_Symbol, PERIOD_CURRENT, 0);
   stGVL.dtTimeCurrent_HigherTF = iTime(_Symbol, eHigherTF, 0);
   
   M_ChangeLabelText("GMTTime", "GMT time " + TimeToString(stGVL.GMTTime,TIME_SECONDS));
   M_ChangeLabelText("ServerTime", "Server time " + TimeToString(stGVL.dtCurrentTime,TIME_SECONDS));
   
}