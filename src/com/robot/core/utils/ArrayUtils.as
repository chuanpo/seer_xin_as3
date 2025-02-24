package com.robot.core.utils
{
   public class ArrayUtils
   {
      public function ArrayUtils()
      {
         super();
      }
      
      public static function eq(a1:Array, a2:Array) : Boolean
      {
         if(a1 == a2)
         {
            return true;
         }
         if(a1.length != a2.length)
         {
            return false;
         }
         for(var i:int = 0; i < a1.length; i++)
         {
            if(a1[i] != a2[i])
            {
               return false;
            }
         }
         return true;
      }
      
      public static function contains(ar:Array, item:*) : Boolean
      {
         if(getItemIndex(ar,item) != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function removeDuplicates(ar:Array) : Array
      {
         var a1:int = 0;
         var a2:int = 0;
         for(a1 = 0; a1 < ar.length; a1++)
         {
            for(a2 = 0; a2 < ar.length; a2++)
            {
               if(ar[a2] == ar[a1])
               {
                  if(a2 != a1)
                  {
                     ar.splice(a2,1);
                  }
               }
            }
         }
         return ar;
      }
      
      public static function shuffle(ar:Array) : Array
      {
         var n:int = 0;
         var tmp:* = undefined;
         var len:int = int(ar.length);
         for(var i:int = 0; i < len; i++)
         {
            n = Math.floor(Math.random() * len);
            tmp = ar[i];
            ar[i] = ar[n];
            ar[n] = tmp;
         }
         return ar;
      }
      
      public static function remove(ar:Array, item:*) : *
      {
         var index:int = getItemIndex(ar,item);
         if(index != -1)
         {
            ar.splice(index,1);
         }
         return item;
      }
      
      public static function getItemIndex(ar:Array, item:*) : int
      {
         var i:int = int(ar.length);
         while(--i > -1)
         {
            if(ar[i] == item)
            {
               return i;
            }
         }
         return -1;
      }
   }
}

