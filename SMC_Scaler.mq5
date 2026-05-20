// Original SMC Scaler by raphix251
#property copyright "raphix251"



// Include all mqh files
// Libraries
#include "IncludeLibrarys.mqh"



//--- INPUT PARAMETERS
// Money Management parameters
input string   Section_MoneyManagement = ""; // ---MONEY MANAGEMENT---
input double   fRiskPerTrade = 1;            // Risk per trade
input int      nMaxTradesPerDay = 5;         // Maximum trades per day
input double   fLossPerLot = 0;              // Loss per lot in dollar
input int      nMaxSpread = 0;               // Maximum spread in points
input double   nMaxDailyProfit = 0;          // Maximum daily profit in percent
input double   nMaxDailyLoss = 0;            // Maximum daily loss in percent

// Strategy parameters
input string   Section_Strategy        = "";    // ---STRATEGY---
input double   fRiskReward = 2.0;               // Risk reward ratio
input int      nNumberOfCandlesLow = 10;        // Number of candles to look for low
input int      nCandlesLookbackFVG = 5;         // Number of candles to look back for fair value gap
input int      nMaxCandlesFVGInverse = 5;       // Maximum candles to inverse FVG
input ENUM_TIMEFRAMES eHigherTF = PERIOD_M15;   // Higher timeframe for liquidity search
input bool     bRunnerPosition = false;       // Runner position (closing when EMAs cross)
input int      nDistanceMoveRunnerSLTP1 = 0;  // Distance to move SL of runner to TP1

// Time filter parameters
input string   Section_TimeFilter      = ""; // ---TIME FILTER---
input int      nStartTime1 = 8;              // Start time
input int      nEndTime1 = 20;               // End time
input int      nStartTime2 = -1;             // Start time
input int      nEndTime2 = -1;               // End time

// News filter parameters
input string   Section_NewsFilter      = ""; // ---NEWS FILTER---
input int      nNewsMinutesBefore = 30;                                          // No entries before news in minutes
input int      nNewsMinutesAfter = 10;                                           // No entries after news in minutes
input ENUM_CALENDAR_EVENT_IMPORTANCE eNewsImportance = CALENDAR_IMPORTANCE_NONE; // Minimum news importance
input string   sNewsCurrency1 = "USD";                                            // News currency to look for
input string   sNewsCurrency2 = "";                                               // News currency to look for
input string   sNewsCurrency3 = "";                                               // News currency to look for
input string   sNewsCurrency4 = "";                                               // News currency to look for
input string   sNewsCurrency5 = "";                                               // News currency to look for

// Debug
input string   Section_Debug           = ""; // ---DEBUG---
input datetime dtDebugTime;                  // Debug time breakpoint (only for testing purpose)

stGlobalVars stGVL;
CTrade Trade;
int nMaxCandles;
int nMaxCandlesHigherTF;
datetime tmpDebugTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   M_Points2Price();
   
   tmpDebugTime = dtDebugTime;
   
   M_SetBoxNames();
   
   M_CreateLabel("FilterLabel",5,10);
   M_CreateLabel("GMTTime",5,40);
   M_CreateLabel("ServerTime",5,80);
   
   nMaxCandles = nNumberOfCandlesLow + 1;
   nMaxCandles = MathMax(nCandlesLookbackFVG + 1,nMaxCandles);
   nMaxCandles = MathMax(nMaxCandlesFVGInverse + 1,nMaxCandles);
   
   nMaxCandlesHigherTF = 3 + 1; // 3 Candles are needed for FVG + 1 because the first one is not closed yet
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   M_GetCandleData(PERIOD_CURRENT, stGVL.Candle, nMaxCandles);
   M_GetCandleData(eHigherTF, stGVL.CandleHigherTF, nMaxCandlesHigherTF);
   
   M_DetermineTimes();
   
   M_StateMachine();
   
   if(stGVL.dtTimeCurrent_CurrTF != stGVL.dtTimeLast_CurrTF)
   {
      M_NewBar_CurrTF();
      stGVL.dtTimeLast_CurrTF = stGVL.dtTimeCurrent_CurrTF;
   }
}