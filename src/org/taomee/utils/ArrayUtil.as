package org.taomee.utils
{
   public class ArrayUtil
   {
      public function ArrayUtil()
      {
         super();
      }
      
      public static function removeValueFromArray(arr:Array, value:Object) : void
      {
         var i:int = int(arr.indexOf(value));
         if(i != -1)
         {
            arr.splice(i,1);
         }
      }
      
      public static function copyArray(arr:Array) : Array
      {
         return arr.slice();
      }
      
      public static function arrayContainsValue(arr:Array, value:Object) : Boolean
      {
         return arr.indexOf(value) != -1;
      }
      
      public static function arraysAreEqual(arr1:Array, arr2:Array) : Boolean
      {
         var isd:Boolean = false;
         if(arr1.length != arr2.length)
         {
            return false;
         }
         isd = Boolean(arr1.every(function(item:Object, index:int, array:Array):Boolean
         {
            if(arr2.indexOf(item) == -1)
            {
               return false;
            }
            return true;
         }));
         if(!isd)
         {
            return false;
         }
         isd = Boolean(arr2.every(function(item:Object, index:int, array:Array):Boolean
         {
            if(arr1.indexOf(item) == -1)
            {
               return false;
            }
            return true;
         }));
         return isd;
      }
      
      public static function embody(arr1:Array, arr2:Array) : Boolean
      {
         var isd:Boolean = Boolean(arr2.every(function(item:Object, index:int, array:Array):Boolean
         {
            if(arr1.indexOf(item) == -1)
            {
               return false;
            }
            return true;
         }));
         return isd;
      }
      
      public static function createUniqueCopy(a:Array) : Array
      {
         var uniqueArr:Array = null;
         uniqueArr = [];
         a.forEach(function(item:Object, index:int, array:Array):void
         {
            if(uniqueArr.indexOf(item) == -1)
            {
               uniqueArr.push(item);
            }
         });
         return uniqueArr;
      }
   }
}

