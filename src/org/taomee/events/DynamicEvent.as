package org.taomee.events
{
   import flash.events.Event;
   
   public class DynamicEvent extends Event
   {
      private var _paramObject:Object;
      
      public function DynamicEvent(type:String, paramObject:Object = null)
      {
         super(type,false,false);
         _paramObject = paramObject;
      }
      
      public function get paramObject() : Object
      {
         return _paramObject;
      }
      
      override public function clone() : Event
      {
         return new DynamicEvent(type,_paramObject);
      }
   }
}

