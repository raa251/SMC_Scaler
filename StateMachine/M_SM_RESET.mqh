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
   stGVL.dtFVGReached_Time = 0;
   
   stGVL.eStateMachine = SM_WAIT_FOR_START;
}