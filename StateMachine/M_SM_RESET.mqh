void M_SM_RESET()
{
   stGVL.BodyStopLoss = 0;
   stGVL.StopLoss = 0;
   stGVL.TakeProfit = 0;
   stGVL.Entry = 0;
   stGVL.eCurrentDirection = DIR_NONE;
   
   stGVL.eStateMachine = SM_RESET;
}