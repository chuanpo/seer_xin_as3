package com.robot.core.newloader
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.ui.loading.Loading;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   [Event(name="close",type="com.robot.core.event.MCLoadEvent")]
   [Event(name="error",type="com.robot.core.event.MCLoadEvent")]
   [Event(name="success",type="com.robot.core.event.MCLoadEvent")]
   public class MCLoader extends EventDispatcher
   {
      private var _loadingView:ILoadingStyle;
      
      private var autoCloseLoading:Boolean;
      
      private var _parentContainer:DisplayObjectContainer;
      
      private var _url:String;
      
      private var _loader:Loader;
      
      private var _isCurrentApp:Boolean;
      
      private var _loadingStyle:int;
      
      private var _loadingTitle:String;
      
      public function MCLoader(url:String = "", parentMC:DisplayObjectContainer = null, loadingStyle:int = -1, loadingTitle:String = "", autoCloseLoading:Boolean = true, isCurrentApp:Boolean = false)
      {
         super();
         this._isCurrentApp = isCurrentApp;
         this._url = url;
         this._parentContainer = parentMC;
         this.autoCloseLoading = autoCloseLoading;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._loadingStyle = loadingStyle;
         this._loadingTitle = loadingTitle;
         this._loadingView = Loading.getLoadingStyle(this._loadingStyle,parentMC,this._loadingTitle);
         this._loadingView.addEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
      }
      
      public function setIsShowClose(i:Boolean) : void
      {
         this._loadingView.setIsShowCloseBtn(i);
      }
      
      public function get sharedEvents() : EventDispatcher
      {
         return this._loader.contentLoaderInfo.sharedEvents;
      }
      
      public function set loadingView(i:ILoadingStyle) : void
      {
         this._loadingView.removeEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
         this._loadingView.destroy();
         this._loadingView = i;
         this._loadingView.addEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
      }
      
      public function doLoad(url:String = "") : void
      {
         var context:LoaderContext = new LoaderContext();
         var vlu:* = getDefinitionByName("com.taomee.utils.VLU");
         if(this._isCurrentApp)
         {
            context.applicationDomain = ApplicationDomain.currentDomain;
         }
         if(url == "")
         {
            if(this._url != "")
            {
               this._loader.load(vlu.getURLRequest(this._url),context);
            }
         }
         else
         {
            this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.openHandler);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.initHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this._loader.load(vlu.getURLRequest(url),context);
         }
      }
      
      private function openHandler(event:Event) : void
      {
         this._loadingView.show();
      }
      
      private function initHandler(evt:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         if(this.autoCloseLoading)
         {
            this._loadingView.close();
         }
         dispatchEvent(new MCLoadEvent(MCLoadEvent.SUCCESS,this));
      }
      
      private function errorHandler(evt:IOErrorEvent) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         dispatchEvent(new MCLoadEvent(MCLoadEvent.ERROR,this));
         trace("加载出错！",this._url);
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         var total:Number = event.bytesTotal;
         var loaded:Number = event.bytesLoaded;
         this._loadingView.changePercent(total,loaded);
      }
      
      public function closeLoading() : void
      {
         if(Boolean(this._loadingView))
         {
            this._loadingView.close();
         }
      }
      
      private function loadingCloseHandler(event:RobotEvent) : void
      {
         dispatchEvent(new MCLoadEvent(MCLoadEvent.CLOSE,this));
         this.clear();
      }
      
      public function clear() : void
      {
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         }
         catch(e:Error)
         {
         }
         if(Boolean(this._loadingView))
         {
            this._loadingView.destroy();
            this._loadingView.removeEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
            this._loadingView = null;
         }
         this._parentContainer = null;
         this._loader = null;
      }
      
      public function getLoadingStyle() : ILoadingStyle
      {
         return this._loadingView;
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
      
      public function set parentMC(i:DisplayObjectContainer) : void
      {
         this._parentContainer = i;
      }
      
      public function get parentMC() : DisplayObjectContainer
      {
         return this._parentContainer;
      }
   }
}

