package com.robot.app.imgPanel
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   
   public class SaveBmp
   {
      private static var file:FileReference;
      
      public function SaveBmp()
      {
         super();
      }
      
      public static function download(url:String) : void
      {
         var downloadURL:URLRequest = new URLRequest();
         downloadURL.url = url;
         file = new FileReference();
         var fileName:String = "赛尔截图_" + new Date().valueOf() + ".jpg";
         configureListeners();
         file.download(downloadURL,fileName);
      }
      
      private static function configureListeners() : void
      {
         file.addEventListener(Event.CANCEL,cancelHandler);
         file.addEventListener(Event.COMPLETE,completeHandler);
         file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function removeConfigureListeners() : void
      {
         file.removeEventListener(Event.CANCEL,cancelHandler);
         file.removeEventListener(Event.COMPLETE,completeHandler);
         file.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function cancelHandler(event:Event) : void
      {
         trace("cancelHandler: " + event);
         removeConfigureListeners();
      }
      
      private static function completeHandler(event:Event) : void
      {
         trace("completeHandler: " + event);
         removeConfigureListeners();
      }
      
      private static function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + event);
         removeConfigureListeners();
      }
      
      private static function progressHandler(event:ProgressEvent) : void
      {
         var file:FileReference = FileReference(event.target);
         trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
      }
      
      private static function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + event);
         removeConfigureListeners();
      }
   }
}

