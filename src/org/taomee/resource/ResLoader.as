package org.taomee.resource
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class ResLoader extends EventDispatcher
   {
      public var resInfo:ResInfo;
      
      private var _loader:Loader;
      
      private var _isLoading:Boolean;
      
      public var level:int;
      
      public function ResLoader()
      {
         super();
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.OPEN,onOpen);
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
         _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
      }
      
      public function get loaderInfo() : LoaderInfo
      {
         return _loader.contentLoaderInfo;
      }
      
      public function set isLoading(b:Boolean) : void
      {
         _isLoading = b;
      }
      
      private function onComplete(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      public function destroy() : void
      {
         close();
         unload();
         resInfo = null;
         _loader.contentLoaderInfo.removeEventListener(Event.OPEN,onOpen);
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
         _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
         _loader = null;
      }
      
      private function onProgress(e:ProgressEvent) : void
      {
         dispatchEvent(e);
      }
      
      public function load(info:ResInfo) : void
      {
         resInfo = info;
         level = resInfo.level;
         resInfo.isLoading = true;
         _isLoading = true;
         _loader.load(new URLRequest(resInfo.url));
      }
      
      private function onOpen(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      private function onError(e:IOErrorEvent) : void
      {
         resInfo.isLoading = false;
         dispatchEvent(e);
         _isLoading = false;
      }
      
      public function close() : void
      {
         if(!_isLoading)
         {
            return;
         }
         _isLoading = false;
         resInfo.isLoading = false;
         try
         {
            _loader.close();
         }
         catch(e:Error)
         {
         }
      }
      
      public function get isLoading() : Boolean
      {
         return _isLoading;
      }
      
      public function unload() : void
      {
         _loader.unload();
      }
   }
}

