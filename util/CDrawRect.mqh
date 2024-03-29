//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDrawRect
{  

   private:
      static int s_index;
      static int s_rectindex;
      static string s_prefix;
      static string s_trend;
   
   public:
   
      static bool CreateLong(int tf);
      static bool CreateShort(int tf);
      static bool Move(int tf);
      static void End();
};

int CDrawRect::s_index = 0;
string CDrawRect::s_prefix = "Rect_";
string CDrawRect::s_trend = "none";//矩形方向
int CDrawRect::s_rectindex = 0;//矩形从刚开始到现在过了几个柱子

//按趋势周期创建
static bool CDrawRect::CreateLong(int tf)
{
   color clr = clrYellow;
   s_trend = "long"; 
   s_index += 1;
   int chart_ID = 0;
   string name = s_prefix+s_index;
   int width = 1;
   datetime time1 = TimeCurrent();
   double price1 = iLow(NULL,tf,1);
   datetime time2 = TimeCurrent();
   double price2 = iHigh(NULL,tf,1);
   int sub_window = 0;
   
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,true);
   //--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   return true;
}

static bool CDrawRect::CreateShort(int tf)
{
   color clr = clrBlue;
   s_trend = "short"; 
   s_index += 1;
   int chart_ID = 0;
   string name = s_prefix+s_index;
   int width = 1;
   datetime time1 = TimeCurrent();
   double price1 = iHigh(NULL,tf,1);
   datetime time2 = TimeCurrent();
   double price2 = iLow(NULL,tf,1);
   int sub_window = 0;
   
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
   {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,true);
   //--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   return true;
}

//按交易周期移动
static bool CDrawRect::Move(int tf)
{
   if(s_trend == "none"){
      return false;
   }
   s_rectindex += 1;
   int chart_ID = 0;
   string name = s_prefix+s_index;
   int point_index = 1;  //0第一个点
   
   if(s_trend == "long"){
      int h = iHighest(NULL,tf,MODE_HIGH,s_rectindex,0);
      double price = High[h];
      datetime time = TimeCurrent();
      if(!ObjectMove(chart_ID,name,point_index,time,price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
   }
   if(s_trend == "short"){
      int l = iLowest(NULL,tf,MODE_LOW,s_rectindex,0);
      double price = Low[l];
      datetime time = TimeCurrent();
      if(!ObjectMove(chart_ID,name,point_index,time,price))
      {
         Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
      }
   }
   
   return(true);
}

static void CDrawRect::End(void)
{
   s_trend = "none";
   s_rectindex = 0;
}