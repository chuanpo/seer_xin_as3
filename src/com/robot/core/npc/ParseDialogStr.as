package com.robot.core.npc
{
   import org.taomee.ds.HashMap;
   
   public class ParseDialogStr
   {
      public static const SPLIT:String = "$$";
      
      private var array:Array = [];
      
      public var emotionMap:HashMap = new HashMap();
      
      private var tempStr:String;
      
      private var colorMap:HashMap = new HashMap();
      
      public function ParseDialogStr(str:String)
      {
         super();
         this.spliceStr(str);
      }
      
      private function spliceStr(str:String) : void
      {
         var s:String = null;
         var t:String = null;
         var s1:String = null;
         var s2:String = null;
         var num:uint = 0;
         var s3:String = null;
         var reg:RegExp = null;
         var count:uint = 0;
         for(var i:uint = 0; i < str.length; i++)
         {
            s = str.charAt(i);
            if(s == "#")
            {
               s1 = str.charAt(i - 1);
               s2 = str.charAt(i + 1);
               num = 0;
               if(s1 != "$" && uint(s2).toString() == s2)
               {
                  this.array.push(str.slice(0,i));
                  s3 = str.substr(i + 1,1 + num);
                  while(uint(s3) < 100 && uint(s3).toString() == s3 && num < str.length)
                  {
                     num++;
                     s3 = str.substr(i + 1,1 + num);
                  }
                  this.tempStr = str.substring(i + 1 + num,str.length);
                  this.emotionMap.add(this.array.length,uint(str.slice(i + 1,i + 1 + num)));
                  this.spliceStr(this.tempStr);
                  return;
               }
            }
            t = str.substr(i,2);
            if(t == "0x")
            {
               this.array.push(str.slice(0,i));
               reg = /[a-z0-9A-Z]/;
               count = 0;
               while(Boolean(reg.test(str.substr(i + 2 + count,1))) && count < 6)
               {
                  count++;
               }
               if(count > 0)
               {
                  this.colorMap.add(this.array.length,str.substr(i + 2,count));
                  this.tempStr = str.substring(i + 2 + count,str.length);
                  this.spliceStr(this.tempStr);
               }
               else
               {
                  this.array.push(t);
                  this.tempStr = str.substring(i + 2,str.length);
                  this.spliceStr(this.tempStr);
               }
               return;
            }
            if(i == str.length - 1)
            {
               this.array.push(str.slice());
               return;
            }
         }
      }
      
      public function getColor(index:uint) : String
      {
         if(!this.colorMap.containsKey(index))
         {
            return "ffffff";
         }
         return this.colorMap.getValue(index);
      }
      
      public function get strArray() : Array
      {
         return this.array;
      }
      
      public function get str() : String
      {
         return this.array.join(SPLIT);
      }
      
      public function getEmotionNum(index:uint) : int
      {
         if(!this.emotionMap.containsKey(index))
         {
            return -1;
         }
         return this.emotionMap.getValue(index);
      }
   }
}

