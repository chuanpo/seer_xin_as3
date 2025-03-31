package com.robot.core.config
{
    import org.taomee.ds.HashMap;
    import com.robot.core.ui.alert.Alarm;

    public class XmlConfig
    {
        private static var xml:XML;

        private static var hashMap:HashMap = new HashMap();

        private static var nameHashMap:HashMap = new HashMap();

        public function XmlConfig()
        {
            super();
        }

        public static function setup(_xml:XML):void
        {
            var i:XML = null;
            xml = _xml;
            for each (i in xml["xml"].elements())
            {
                hashMap.add(String(i.@path), String(i.@ver));
                nameHashMap.add(String(i.@path), String(i.@name));
            }
        }

        public static function getXmlVerByPath(path:String):String
        {
            if (!hashMap.containsKey(path))
            {
                return "";
            }
            return hashMap.getValue(path);
        }
        public static function getXmlNameByPath(path:String):String
        {
            if (!nameHashMap.containsKey(path))
            {
                return "";
            }
            return nameHashMap.getValue(path);
        }
    }
}
