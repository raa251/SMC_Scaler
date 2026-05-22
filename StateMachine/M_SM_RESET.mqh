void M_SM_RESET()
{
   stGVL.BodyStopLoss = 0;
   stGVL.StopLoss = 0;
   stGVL.TakeProfit = 0;
   stGVL.Entry = 0;
   stGVL.eCurrentDirection = DIR_NONE;
   
   stGVL.LastFVGTop = 0;
   stGVL.LastFVGBottom = 0;
   stGVL.LastFVGIndex = 0;
   
   stGVL.LastFVGTop_HTF = 0;
   stGVL.LastFVGBottom_HTF = 0;
   stGVL.LastFVGIndex_HTF = 0;
   stGVL.dtFVGReached_Time_HTF = 0;
   stGVL.dtFVGCreated_Time_HTF = 0;
   
   stGVL.bTPChecked = false;
   stGVL.bRunnerPosition_CheckClose = false;
   stGVL.MovedBE = false;
   
   stGVL.eStateMachine = SM_WAIT_FOR_START;
}