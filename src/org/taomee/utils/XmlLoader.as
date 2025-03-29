package org.taomee.utils
{
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import com.robot.core.ui.alert.Alarm;
    public class XmlLoader
    {
        public static const XML_PATH:String = "resource/xml/";

        public function XmlLoader()
        {
            super();
        }

        public static function loadXML(url:String, ver:String, handle:Function):void
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
                    var xmlData:XML = new XML(event.target.data);
                    handle(xmlData)
                }
                errorHandler = function(event:IOErrorEvent):void
                {
                    urlloader.removeEventListener(Event.COMPLETE,onComplete)
                    urlloader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler)
                    var xmlData:XML = new XML();
                    handle(xmlData)
                }
                urlloader.addEventListener(Event.COMPLETE, onComplete);
                urlloader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                urlloader.load(new URLRequest(XML_PATH + url + ".xml?" + ver));
            }
            catch (error:Error)
            {
                Alarm.show(error)
            }
        }
    }
}
