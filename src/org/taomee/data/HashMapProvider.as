package org.taomee.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import org.taomee.ds.HashMap;
   
   [Event(name="dataChange",type="fl.events.DataChangeEvent")]
   [Event(name="preDataChange",type="fl.events.DataChangeEvent")]
   public class HashMapProvider extends EventDispatcher
   {
      private var _data:HashMap = new HashMap();
      
      public var autoUpdate:Boolean = true;
      
      public function HashMapProvider()
      {
         super();
      }
      
      public function containsKey(key:*) : Boolean
      {
         return _data.containsKey(key);
      }
      
      protected function dispatchPreChangeEvent(evtType:String, items:Array) : void
      {
         if(!autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE,evtType,items));
         }
      }
      
      public function dispatchSelectMulti(ed:IEventDispatcher, keys:Array, values:Array) : void
      {
         var len:int = int(keys.length);
         for(var i:int = 0; i < len; i++)
         {
            _data.add(keys[i],values[i]);
         }
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,values.concat()));
      }
      
      public function remove(key:*) : *
      {
         var value:* = _data.remove(key);
         if(value)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,[value]);
            return value;
         }
         return null;
      }
      
      public function addMulti(keys:Array, values:Array) : Array
      {
         var old:* = undefined;
         var arr:Array = [];
         var len:int = int(keys.length);
         for(var i:int = 0; i < len; i++)
         {
            old = _data.add(keys[i],values[i]);
            if(old)
            {
               arr.push(old);
            }
         }
         dispatchChangeEvent(DataChangeType.ADD,values.concat());
         return arr;
      }
      
      public function removeForValue(value:*) : *
      {
         var v:* = undefined;
         var key:* = _data.getKey(value);
         if(key)
         {
            v = _data.remove(key);
            if(v)
            {
               dispatchChangeEvent(DataChangeType.REMOVE,[v]);
               return v;
            }
         }
         return null;
      }
      
      public function removeMulti(keys:Array) : Array
      {
         var key:* = undefined;
         var value:* = undefined;
         var arr:Array = [];
         for each(key in keys)
         {
            value = _data.remove(key);
            if(value)
            {
               arr.push(value);
            }
         }
         if(arr.length > 0)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,arr.concat());
         }
         return arr;
      }
      
      public function dispatchSelect(ed:IEventDispatcher, key:*, value:*) : void
      {
         _data.add(key,value);
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,[value]));
      }
      
      public function getValues() : Array
      {
         return _data.getValues();
      }
      
      public function containsValue(value:*) : Boolean
      {
         return _data.containsValue(value);
      }
      
      public function refresh() : void
      {
         dispatchChangeEvent(DataChangeType.RESET,_data.getValues());
      }
      
      public function removeMultiForValue(values:Array) : Array
      {
         var value:* = undefined;
         var key:* = undefined;
         var v:* = undefined;
         var arr:Array = [];
         for each(value in values)
         {
            key = _data.getKey(value);
            if(key)
            {
               v = _data.remove(key);
               if(v)
               {
                  arr.push(v);
               }
            }
         }
         if(arr.length > 0)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,arr.concat());
         }
         return arr;
      }
      
      public function upDateForKey(key:*, newV:*) : void
      {
         var oldV:* = undefined;
         if(_data.containsKey(key))
         {
            oldV = _data.add(key,newV);
            if(oldV)
            {
               dispatchPreChangeEvent(DataChangeType.UPDATE,[oldV]);
            }
            dispatchChangeEvent(DataChangeType.UPDATE,[newV]);
         }
      }
      
      public function add(key:*, value:*) : *
      {
         var old:* = _data.add(key,value);
         dispatchChangeEvent(DataChangeType.ADD,[value]);
         return old;
      }
      
      public function get length() : uint
      {
         return _data.length;
      }
      
      public function getKey(value:*) : *
      {
         return _data.getKey(value);
      }
      
      public function getKeys() : Array
      {
         return _data.getKeys();
      }
      
      public function upDateForValue(oldV:*, newV:*) : void
      {
         var key:* = _data.getKey(oldV);
         if(key)
         {
            _data.add(key,newV);
            dispatchPreChangeEvent(DataChangeType.UPDATE,[oldV]);
            dispatchChangeEvent(DataChangeType.UPDATE,[newV]);
         }
      }
      
      protected function dispatchChangeEvent(evtType:String, items:Array) : void
      {
         if(!autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items));
         }
      }
      
      public function toHashMap() : HashMap
      {
         return _data.clone();
      }
      
      public function getValue(key:*) : *
      {
         return _data.getValue(key);
      }
      
      public function removeAll() : void
      {
         var arr:Array = _data.getValues();
         _data.clear();
         dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr);
      }
   }
}

