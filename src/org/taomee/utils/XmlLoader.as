package org.taomee.utils
{
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import com.robot.core.ui.alert.Alarm;
    import com.robot.core.ui.loading.Loading;
    import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
    import com.robot.core.manager.MainManager;
    import com.robot.core.config.XmlConfig;
    import flash.events.ProgressEvent;

    public class XmlLoader
    {
        public const XML_PATH:String = "resource/xml/";

        // public static var loadingView:Loading;

        public var _loadingView:ILoadingStyle;

        public function XmlLoader()
        {
            super();
        }

        public function loadXML(url:String, ver:String, handle:Function):void
        {
            try
            {
                var urlloader:URLLoader = new URLLoader();
                var onComplete:Function = null;
                var errorHandler:Function = null;
                onComplete = function(event:Event):void
                {
                    urlloader.removeEventListener(Event.COMPLETE,onComplete);
                    urlloader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                    urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
                    if(_loadingView)
                    {
                        _loadingView.destroy();
                        _loadingView = null;
                    }
                    var xmlData:XML = new XML(event.target.data);
                    handle(xmlData);
                }
                errorHandler = function(event:IOErrorEvent):void
                {
                    urlloader.removeEventListener(Event.COMPLETE,onComplete);
                    urlloader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                    urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
                    if(_loadingView)
                    {
                        _loadingView.destroy();
                        _loadingView = null;
                    }
                    Alarm.show("xml加载" + XmlConfig.getXmlNameByPath(url) + "失败！")
                    var xmlData:XML = new XML();
                    handle(xmlData);
                }
                urlloader.addEventListener(Event.COMPLETE, onComplete);
                urlloader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                urlloader.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
                if(_loadingView)
                {
                    _loadingView.destroy();
                    _loadingView = null;
                }
                _loadingView = Loading.getLoadingStyle(1,MainManager.getStage(),"加载XML_" + XmlConfig.getXmlNameByPath(url) + "中");
                _loadingView.setIsShowCloseBtn(false);
                urlloader.load(new URLRequest(XML_PATH + url + ".xml?" + ver));
                
            }
            catch (error:Error)
            {
                Alarm.show(error)
            }
        }

        private function progressHandler(event:ProgressEvent) : void
        {
            var total:Number = event.bytesTotal;
            var loaded:Number = event.bytesLoaded;
            this._loadingView.changePercent(total,loaded);
        }
    }
}
