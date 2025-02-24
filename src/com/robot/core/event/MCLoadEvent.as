package com.robot.core.event
{
   import com.robot.core.newloader.MCLoader;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class MCLoadEvent extends Event
   {
      public static var SUCCESS:String = "success";
      
      public static var ERROR:String = "error";
      
      public static var CLOSE:String = "close";
      
      private var mcloader:MCLoader;
      
      private var content:DisplayObject;
      
      public function MCLoadEvent(type:String, mcloader:MCLoader, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mcloader = mcloader;
      }
      
      public function getParent() : DisplayObjectContainer
      {
         return this.mcloader.parentMC;
      }
      
      public function getLoader() : Loader
      {
         return this.mcloader.loader;
      }
      
      public function getContent() : DisplayObject
      {
         return this.mcloader.loader.content;
      }
      
      public function getApplicationDomain() : ApplicationDomain
      {
         return this.getLoader().contentLoaderInfo.applicationDomain;
      }
   }
}

