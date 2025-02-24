package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class HashMap implements ICollection
   {
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashMap(weakKeys:Boolean = false)
      {
         super();
         _weakKeys = weakKeys;
         _length = 0;
         _content = new Dictionary(weakKeys);
      }
      
      public function containsKey(key:*) : Boolean
      {
         if(_content[key] === undefined)
         {
            return false;
         }
         return true;
      }
      
      public function remove(key:*) : *
      {
         if(_content[key] === undefined)
         {
            return null;
         }
         var temp:* = _content[key];
         delete _content[key];
         --_length;
         return temp;
      }
      
      public function some(func:Function) : Boolean
      {
         var i:* = undefined;
         for(i in _content)
         {
            if(func(i,_content[i]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function clear() : void
      {
         _length = 0;
         _content = new Dictionary(_weakKeys);
      }
      
      public function each2(func:Function) : void
      {
         var i:* = undefined;
         for(i in _content)
         {
            func(i,_content[i]);
         }
      }
      
      public function isEmpty() : Boolean
      {
         return _length == 0;
      }
      
      public function getValues() : Array
      {
         var i:* = undefined;
         var temp:Array = new Array(_length);
         var index:int = 0;
         for each(i in _content)
         {
            temp[index] = i;
            index++;
         }
         return temp;
      }
      
      public function containsValue(value:*) : Boolean
      {
         var i:* = undefined;
         for each(i in _content)
         {
            if(i === value)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clone() : HashMap
      {
         var i:* = undefined;
         var temp:HashMap = new HashMap(_weakKeys);
         for(i in _content)
         {
            temp.add(i,_content[i]);
         }
         return temp;
      }
      
      public function eachKey(func:Function) : void
      {
         var i:* = undefined;
         for(i in _content)
         {
            func(i);
         }
      }
      
      public function add(key:*, value:*) : *
      {
         var oldValue:* = undefined;
         if(key == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         if(value === undefined)
         {
            return null;
         }
         if(_content[key] === undefined)
         {
            ++_length;
         }
         oldValue = getValue(key);
         _content[key] = value;
         return oldValue;
      }
      
      public function get length() : int
      {
         return _length;
      }
      
      public function getKey(value:*) : *
      {
         var i:* = undefined;
         for(i in _content)
         {
            if(_content[i] == value)
            {
               return i;
            }
         }
         return null;
      }
      
      public function getKeys() : Array
      {
         var i:* = undefined;
         var temp:Array = new Array(_length);
         var index:int = 0;
         for(i in _content)
         {
            temp[index] = i;
            index++;
         }
         return temp;
      }
      
      public function toString() : String
      {
         var i:int = 0;
         var ks:Array = getKeys();
         var vs:Array = getValues();
         var len:int = int(ks.length);
         var temp:String = "HashMap Content:\n";
         for(i = 0; i < len; i++)
         {
            temp += ks[i] + " -> " + vs[i] + "\n";
         }
         return temp;
      }
      
      public function eachValue(func:Function) : void
      {
         var i:* = undefined;
         for each(i in _content)
         {
            func(i);
         }
      }
      
      public function filter(func:Function) : Array
      {
         var i:* = undefined;
         var v:* = undefined;
         var arr:Array = [];
         for(i in _content)
         {
            v = _content[i];
            if(func(i,v))
            {
               arr.push(v);
            }
         }
         return arr;
      }
      
      public function getValue(key:*) : *
      {
         var value:* = _content[key];
         return value === undefined ? null : value;
      }
   }
}

