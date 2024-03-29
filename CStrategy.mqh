//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015    |
//|                                              yangjx009@139.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"


#include "base\CMacd.mqh";
#include "base\CLaguerreRsi.mqh";

#include "util\CDrawLine.mqh";
#include "util\CDrawRect.mqh";
#include "util\CDrawArrow.mqh";


#include "trade\CTrade.mqh";
#include "trade\CTicket.mqh";
#include "trade\CTrend.mqh";
#include "trade\CFilter.mqh";

class CStrategy
{  
   private:
     datetime CheckTimeTrend;
     datetime CheckTimeFilter;
     datetime CheckTimeEntry; 
     double   Lots;
     int      Tp;
     int      Sl;
     int      TrendTF;
     int      FilterTF;
     int      EntryTF;
     
     CTrade* oCTrade;
     
     CLaguerreRsi* oCLRsi_Trend;
     CMacd* oMacdMain_Trend;
     CTrend* oCTrend;
     
     CLaguerreRsi* oCLRsi_Filter;
     CMacd* oMacdMain_Filter;
     CFilter* oCFilter;
     
     CLaguerreRsi* oCLRsi_Entry;
     CMacd* oMacdMain_Entry;
     CMacd* oMacdSignal_Entry;
     
     
    
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
     
     
   public:
      
      CStrategy(int Magic, int Input_TrendTF, int Input_FilterTF, int Input_EntryTF){
         TrendTF  = Input_TrendTF;
         FilterTF = Input_FilterTF;
         EntryTF  = Input_EntryTF;
         
         oCTrade        = new CTrade(Magic);
         
         oCLRsi_Trend = new CLaguerreRsi(TrendTF,0);
         oMacdMain_Trend = new CMacd(TrendTF,MODE_MAIN);
         oCLRsi_Filter = new CLaguerreRsi(FilterTF,0);
         oMacdMain_Filter = new CMacd(FilterTF,MODE_MAIN);
         oCLRsi_Entry = new CLaguerreRsi(EntryTF,0);
         oMacdMain_Entry = new CMacd(EntryTF,MODE_MAIN);
         oMacdSignal_Entry = new CMacd(EntryTF,MODE_SIGNAL);
        
         oCTrend = new CTrend(TrendTF, oCLRsi_Trend, oMacdMain_Trend);
         oCFilter = new CFilter(FilterTF,oCTrend,oCLRsi_Filter,oMacdMain_Filter);
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Entry();
      void Exit();
      void CheckOpen();
      string getTrend();
      
};

void CStrategy::Init(double _lots, int _tp, int _sl)
{
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategy::Tick(void)
{  
    
    //every M5
    if(CheckTimeEntry != iTime(NULL,EntryTF,0)){
         CheckTimeEntry = iTime(NULL,EntryTF,0);
         this.Update();
         oCTrend.TickEntry(EntryTF);
         Entry();
    }
    
    //every H1
    if(CheckTimeTrend != iTime(NULL,TrendTF,0)){
         CheckTimeTrend = iTime(NULL,TrendTF,0);
         oCTrend.Tick();
    }
    
    
    if(CheckTimeFilter != iTime(NULL,FilterTF,0)){
         CheckTimeFilter = iTime(NULL,FilterTF,0);
         oCFilter.Tick();
    }
    
   // CheckOpen();
}



void CStrategy::Update()
{
   oCLRsi_Trend.Fill();
   oMacdMain_Trend.Fill();
   oMacdMain_Filter.Fill();
   oCLRsi_Filter.Fill();
   //oCTicket.Update();
   oCLRsi_Entry.Fill();
   oMacdMain_Entry.Fill();
   oMacdSignal_Entry.Fill();
}

string CStrategy::getTrend()
{
   return oCTrend.GetTrend();
}

void CStrategy::GetTrend()
{

   
}


void CStrategy::OnTrendChange()
{
   
}


void CStrategy::Exit()
{
   
}

void CStrategy::Entry()
{
   string t = oCTrend.GetTrend();
   if(t=="long"){
      if((oCLRsi_Entry.data[2] <=0.15 && oCLRsi_Entry.data[1]>0.15) ||  (oCLRsi_Entry.data[2] <=0 && oCLRsi_Entry.data[1]>0)){
         if(oMacdSignal_Entry.data[1]<-0.01 ){
            if(oMacdMain_Entry.data[1] > oMacdSignal_Entry.data[1]){
               //if(MathAbs(oMacdMain_Entry.data[1] - oMacdMain_Entry.LowValue(10))<0.02){
               //if(oMacdMain_Entry.LowValue(10)<-0.02){
                  CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-18*oCTrade.GetPip());
               //}
               
            }
         }
      }
   }
   if(t == "short"){
      if((oCLRsi_Entry.data[2] >=0.85 && oCLRsi_Entry.data[1]<0.85) ||  (oCLRsi_Entry.data[2] >=1 && oCLRsi_Entry.data[1]<1)){
         if(oMacdSignal_Entry.data[1]>0.01 ){
            if(oMacdMain_Entry.data[1] < oMacdSignal_Entry.data[1]){
               //if(MathAbs(oMacdMain_Entry.HighValue(10)-oMacdMain_Entry.data[1])<0.02){
              // if(oMacdMain_Entry.HighValue(10)>0.02){
                  CDrawArrow::ArrowDown(TimeCurrent(),High[1]+18*oCTrade.GetPip());
              // }
               
            }
         }
      }
   }
}