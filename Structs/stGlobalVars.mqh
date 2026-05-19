#include "E_DIRECTION.mqh"
#include "E_StateMachine.mqh"

struct stGlobalVars
{
   E_DIRECTION eCurrentDirection;
   E_StateMachine eStateMachine;
   E_StateMachine eStateMachine_Last;
   MqlRates Candle[];
   datetime dtCurrentTime;
   datetime dtCurrentDay;
   datetime dtLastDay;
   datetime dtTimeCurrent_CurrTF;
   datetime dtTimeLast_CurrTF;
   int nActualHour;
   int nNumberOfTrades;
   int nNumberOfPositions;
   
   double BodyStopLoss;
   double StopLoss;
   double TakeProfit;
   double Entry;
   double LotSize;
   
   MqlCalendarValue NewsValues[];
   bool bFilterActive;
   double DailyStartingBalance;
   
   bool MovedBE;
   bool bRunnerPosition_CheckClose;
   
   datetime ServerTime;
   datetime GMTTime;
};