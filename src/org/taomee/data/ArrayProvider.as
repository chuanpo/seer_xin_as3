package org.taomee.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   [Event(name="dataChange",type="fl.events.DataChangeEvent")]
   [Event(name="preDataChange",type="fl.events.DataChangeEvent")]
   public class ArrayProvider extends EventDispatcher
   {
      private var _data:Array = [];
      
      public var autoUpdate:Boolean = true;
      
      public function ArrayProvider(data:Array = null)
      {
         super();
         if(Boolean(data))
         {
            _data = data.concat();
         }
      }
      
      protected function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1) : void
      {
         if(!autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE,evtType,items,startIndex,endIndex));
         }
      }
      
      public function shift() : *
      {
         var item:* = _data.shift();
         dispatchChangeEvent(DataChangeType.REMOVE,[item],0,0);
         return item;
      }
      
      public function dispatchSelectMulti(ed:IEventDispatcher, items:Array) : void
      {
         var len:int = _data.length - 1;
         _data.splice(len,0,items);
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,items,len,_data.length - 1));
      }
      
      public function remove(item:*) : *
      {
         var index:int = int(_data.indexOf(item));
         if(index != -1)
         {
            return removeAt(index)[0];
         }
         return null;
      }
      
      public function getItemIndex(item:*) : int
      {
         return _data.indexOf(item);
      }
      
      public function removeAll() : void
      {
         var arr:Array = _data.concat();
         _data = [];
         dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length - 1);
      }
      
      public function pop() : *
      {
         var item:* = _data.pop();
         var len:int = int(_data.length);
         dispatchChangeEvent(DataChangeType.REMOVE,[item],len,len);
         return item;
      }
      
      public function removeMulti(items:Array) : Array
      {
         var arr:Array = null;
         arr = [];
         _data = _data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(items.indexOf(item) == -1)
            {
               return true;
            }
            arr.push(item);
            return false;
         },this);
         if(arr.length > 0)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function dispatchSelect(ed:IEventDispatcher, item:*) : void
      {
         var index:int = int(_data.push(item));
         ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,[item],index,index));
      }
      
      public function removeAt(index:uint, count:uint = 1) : Array
      {
         checkIndex(index);
         var arr:Array = _data.splice(index,count);
         dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),index,index + arr.length - 1);
         return arr;
      }
      
      public function swapItemAt(item1:*, item2:*) : void
      {
         var index1:int = int(_data.indexOf(item1));
         if(index1 == -1)
         {
            return;
         }
         var index2:int = int(_data.indexOf(item2));
         if(index2 == -1)
         {
            return;
         }
         swapIndexAt(index1,index2);
      }
      
      public function removeForProperty(p:String, value:*) : *
      {
         var _item:* = undefined;
         var _index:int = 0;
         var b:Boolean = Boolean(_data.some(function(item:*, index:int, array:Array):Boolean
         {
            if(item[p] == value)
            {
               _item = item;
               _index = index;
               return true;
            }
            return false;
         },this));
         if(b)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,[_item],_index,_index);
         }
         return _item;
      }
      
      public function refresh() : void
      {
         dispatchChangeEvent(DataChangeType.RESET,_data.concat(),0,_data.length - 1);
      }
      
      public function getItemAt(index:uint) : *
      {
         checkIndex(index);
         return _data[index];
      }
      
      public function sortOn(fieldName:Object, options:Object = null) : Array
      {
         dispatchPreChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length - 1);
         var arr:Array = _data.sortOn(fieldName,options);
         dispatchChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length - 1);
         return arr;
      }
      
      public function sort(... args) : Array
      {
         dispatchPreChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length - 1);
         var arr:Array = _data.sort(args);
         dispatchChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length - 1);
         return arr;
      }
      
      public function contains(item:*) : Boolean
      {
         if(_data.indexOf(item) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function add(item:*) : void
      {
         var index:int = int(_data.push(item));
         dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
      }
      
      public function every(callback:Function, thisObject:* = null) : Boolean
      {
         return _data.every(callback,thisObject);
      }
      
      public function upDateItem(oldItem:*, newItem:*) : *
      {
         var index:int = int(_data.indexOf(oldItem));
         if(index != -1)
         {
            return upDateItemAt(index,newItem);
         }
         return null;
      }
      
      public function toArray() : Array
      {
         return _data.concat();
      }
      
      public function get length() : uint
      {
         return _data.length;
      }
      
      public function addMulti(items:Array) : void
      {
         addMultiAt(items,_data.length - 1);
      }
      
      public function setItemIndexAt(index:int, newIndex:int) : void
      {
         checkIndex(index);
         checkIndex(newIndex);
         var arr:Array = _data.splice(index,1);
         _data.splice(newIndex,0,arr);
         dispatchChangeEvent(DataChangeType.MOVE,arr,index,newIndex);
      }
      
      public function removeMultiForProperty(p:String, value:*) : Array
      {
         var arr:Array = null;
         arr = [];
         _data = _data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(item[p] == value)
            {
               arr.push(item);
               return false;
            }
            return true;
         },this);
         if(arr.length == 0)
         {
            return arr;
         }
         dispatchChangeEvent(DataChangeType.REMOVE,arr,0,arr.length - 1);
         return arr;
      }
      
      public function setItemIndex(item:*, newIndex:int) : void
      {
         checkIndex(newIndex);
         var index:int = int(_data.indexOf(item));
         if(index == -1)
         {
            return;
         }
         setItemIndexAt(index,newIndex);
      }
      
      public function addMultiAt(items:Array, index:uint) : void
      {
         checkIndex(index);
         _data.splice(index,0,items);
         dispatchChangeEvent(DataChangeType.ADD,items.concat(),index,index + items.length - 1);
      }
      
      override public function toString() : String
      {
         return "ArrayProvider [" + _data.join(" , ") + "]";
      }
      
      public function upDateItemAt(index:uint, newItem:*) : *
      {
         checkIndex(index);
         var oldItem:* = _data[index];
         dispatchPreChangeEvent(DataChangeType.UPDATE,[oldItem],index,index);
         _data[index] = newItem;
         dispatchChangeEvent(DataChangeType.UPDATE,[newItem],index,index);
         return oldItem;
      }
      
      protected function checkIndex(index:int) : void
      {
         if(index > _data.length - 1 || index < 0)
         {
            throw new RangeError("ArrayProvider index (" + index.toString() + ") is not in acceptable range (0 - " + (_data.length - 1).toString() + ")");
         }
      }
      
      public function addAt(item:*, index:uint) : void
      {
         checkIndex(index);
         _data.splice(index,0,item);
         dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
      }
      
      protected function dispatchChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1) : void
      {
         if(!autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
         }
      }
      
      public function filter(callback:Function, thisObject:* = null) : Array
      {
         return _data.filter(callback,thisObject);
      }
      
      public function forEach(callback:Function, thisObject:* = null) : void
      {
         _data.forEach(callback,thisObject);
      }
      
      public function some(callback:Function, thisObject:* = null) : Boolean
      {
         return _data.some(callback,thisObject);
      }
      
      public function removeMultiIndex(indexs:Array) : Array
      {
         var arr:Array = null;
         arr = [];
         _data = _data.filter(function(item:*, index:int, array:Array):Boolean
         {
            if(indexs.indexOf(index) == -1)
            {
               return true;
            }
            arr.push(item);
            return false;
         },this);
         if(arr.length > 0)
         {
            dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function map(callback:Function, thisObject:* = null) : Array
      {
         return _data.map(callback,thisObject);
      }
      
      public function swapIndexAt(index1:int, index2:int) : void
      {
         var arr1:Array = null;
         var arr2:Array = null;
         if(index1 == index2)
         {
            return;
         }
         checkIndex(index1);
         checkIndex(index2);
         if(index1 < index2)
         {
            arr2 = _data.splice(index2,1);
            arr1 = _data.splice(index1,1,arr2);
            _data.splice(index2,1,arr1);
            dispatchChangeEvent(DataChangeType.SWAP,arr2.concat(arr1),index1,index2);
         }
         else
         {
            arr1 = _data.splice(index1,1);
            arr2 = _data.splice(index2,1);
            _data.splice(index1,1,arr2);
            dispatchChangeEvent(DataChangeType.SWAP,arr1.concat(arr2),index2,index1);
         }
      }
   }
}

