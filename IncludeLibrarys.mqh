#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>

#include "Filters/EMA/M_CalcCurrentEMA.mqh"
#include "Filters/EMA/M_EMA_INIT.mqh"
#include "Filters/EMA/M_EMABearish.mqh"
#include "Filters/EMA/M_EMABullish.mqh"
#include "Filters/EMA/M_EMACloseBuy.mqh"
#include "Filters/EMA/M_EMACloseSell.mqh"

#include "StateMachine/M_StateMachine.mqh"

#include "Structs/stGlobalVars.mqh"

#include "Utilities/Log/M_LogError.mqh"
#include "Utilities/Log/M_LogInfo.mqh"
#include "Utilities/Log/M_LogWarning.mqh"
#include "Utilities/M_CalculateLotSize.mqh"
#include "Utilities/M_DetermineTimes.mqh"
#include "Utilities/M_GetCandleData.mqh"
#include "Utilities/M_NewBar_CurrTF.mqh"
#include "Utilities/M_NewBar_HigherTF.mqh"
#include "Utilities/M_Points2Price.mqh"
#include "Utilities/M_NewDay.mqh"
#include "Utilities/M_RecalculateTP.mqh"
#include "Utilities/M_CloseRunner.mqh"
#include "Utilities/M_CheckRunnerToTp1.mqh"
#include "Utilities/M_AllSLToEntry.mqh"
#include "Utilities/M_ModifyPositionSL.mqh"
#include "Utilities/M_MoveBE.mqh"

#include "Filters/M_NewsOK.mqh"
#include "Filters/M_FiltersOK.mqh"
#include "Filters/M_GetCurrencyByEvent.mqh"
#include "Filters/M_SessionFilterOK.mqh"
#include "Filters/M_SpreadOK.mqh"
#include "Filters/M_MaxTradesPerDayOK.mqh"
#include "Filters/M_MaxDailyProfitOK.mqh"
#include "Filters/M_MaxDailyLossOK.mqh"

#include "Visualize/Label/M_ChangeLabelText.mqh"
#include "Visualize/Label/M_CreateLabel.mqh"
#include "Visualize/Box/M_CreateBox.mqh"
#include "Visualize/Box/M_ExtendBox.mqh"
#include "Visualize/Box/M_HandleBoxes.mqh"
#include "Visualize/Box/M_SetBoxNames.mqh"