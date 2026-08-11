void M_SM_RESET()
{
   stGVL.BodyStopLoss = 0;
   stGVL.StopLoss = 0;
   stGVL.TakeProfit = 0;
   stGVL.Entry = 0;
   stGVL.eCurrentDirection = DIR_NONE;
   
   stGVL.stFVG.Top = 0;
   stGVL.stFVG.Bottom = 0;
   stGVL.stFVG.Start_Time = 0;
   stGVL.stFVG.End_Time = 0;

   stGVL.stFVG_HTF.Top = 0;
   stGVL.stFVG_HTF.Bottom = 0;
   stGVL.stFVG_HTF.Start_Time = 0;
   stGVL.stFVG_HTF.End_Time = 0;
   stGVL.dtFVGReached_Time_HTF = 0;
   stGVL.dtFVGCreated_Time_HTF = 0;
   
   stGVL.bTPChecked = false;
   stGVL.bRunnerPosition_CheckClose = false;
   stGVL.MovedBE = false;
   
   stGVL.eStateMachine = SM_WAIT_FOR_START;
}