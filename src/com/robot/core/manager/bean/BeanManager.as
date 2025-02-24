package com.robot.core.manager.bean
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.XMLLoadEvent;
   import com.robot.core.newloader.XMLLoader;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import org.taomee.manager.EventManager;
   
   public class BeanManager
   {
      private static var xmlData:XMLList;
      
      private static var dataArray:Array;
      
      private static var dataDictionary:Dictionary;
      
      public static const BEAN_FINISH:String = "beanFinish";
      
      private static const ID_NODE:String = "id";
      
      private static const CLASS_NODE:String = "class";
      
      public function BeanManager()
      {
         super();
      }
      
      public static function start() : void
      {
         var cls:* = getDefinitionByName("DLLLoader");
         xmlData = cls.getBeanXML();
         parseXML();
      }
      
      private static function failLoadHandler(event:XMLLoadEvent) : void
      {
         var xmlloader:XMLLoader = event.currentTarget as XMLLoader;
         xmlloader.removeEventListener(XMLLoadEvent.ERROR,failLoadHandler);
         trace("BEAN配置文件加载错误！！");
      }
      
      private static function parseXML() : void
      {
         var i:XML = null;
         var _id:String = null;
         var _class:String = null;
         dataArray = [];
         dataDictionary = new Dictionary(true);
         for each(i in xmlData.elements())
         {
            _id = i.attribute(ID_NODE).toString();
            _class = i.attribute(CLASS_NODE).toString();
            dataArray.push({
               "id":_id,
               "classPath":_class
            });
         }
         EventManager.addEventListener(BEAN_FINISH,initClasses);
         initClasses();
      }
      
      private static function initClasses(event:Event = null) : void
      {
         var cls:Class = null;
         var instance:* = undefined;
         if(dataArray.length > 0)
         {
            cls = getDefinitionByName(dataArray[0]["classPath"]) as Class;
            instance = new cls();
            dataDictionary[dataArray[0]["id"]] = instance;
            dataArray.shift();
            trace(instance,"实例化完成");
            instance.start();
         }
         else
         {
            EventManager.removeEventListener(BeanManager.BEAN_FINISH,initClasses);
            EventManager.dispatchEvent(new Event(RobotEvent.BEAN_COMPLETE));
         }
      }
      
      public static function getBeanInstance(KEY:String) : *
      {
         return dataDictionary[KEY];
      }
   }
}

