package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class HashSet implements ICollection
   {
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashSet(weakKeys:Boolean = false)
      {
         super();
         _weakKeys = weakKeys;
         _content = new Dictionary(weakKeys);
         _length = 0;
      }
      
      public function addAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            add(i);
         }
      }
      
      public function add(o:*) : void
      {
         if(o === undefined)
         {
            return;
         }
         if(_content[o] === undefined)
         {
            ++_length;
         }
         _content[o] = o;
      }
      
      public function containsAll(arr:Array) : Boolean
      {
         var i:int = 0;
         var len:int = int(arr.length);
         for(i = 0; i < len; i++)
         {
            if(_content[arr[i]] === undefined)
            {
               return false;
            }
         }
         return true;
      }
      
      public function isEmpty() : Boolean
      {
         return _length == 0;
      }
      
      public function remove(o:*) : Boolean
      {
         if(_content[o] !== undefined)
         {
            delete _content[o];
            --_length;
            return true;
         }
         return false;
      }
      
      public function get length() : int
      {
         return _length;
      }
      
      public function clone() : HashSet
      {
         var o:* = undefined;
         var csd:HashSet = new HashSet(_weakKeys);
         for each(o in _content)
         {
            csd.add(o);
         }
         return csd;
      }
      
      public function each2(func:Function) : void
      {
         var i:* = undefined;
         for each(i in _content)
         {
            func(i);
         }
      }
      
      public function clear() : void
      {
         _content = new Dictionary(_weakKeys);
         _length = 0;
      }
      
      public function removeAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            remove(i);
         }
      }
      
      public function toArray() : Array
      {
         var i:* = undefined;
         var arr:Array = new Array(_length);
         var index:int = 0;
         for each(i in _content)
         {
            arr[index] = i;
            index++;
         }
         return arr;
      }
      
      public function contains(o:*) : Boolean
      {
         if(_content[o] === undefined)
         {
            return false;
         }
         return true;
      }
   }
}

