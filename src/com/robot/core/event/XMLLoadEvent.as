package com.robot.core.event
{
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class XMLLoadEvent extends Event
   {
      public static var ON_SUCCESS:String = "onSuccess";
      
      public static var ERROR:String = "error";
      
      private var urlloader:URLLoader;
      
      private var _xml:XML;
      
      public function XMLLoadEvent(type:String, urlloader:URLLoader, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.urlloader = urlloader;
      }
      
      public function getXML() : XML
      {
         return new XML(this.urlloader.data);
      }
   }
}

