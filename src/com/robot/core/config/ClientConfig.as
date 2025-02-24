package com.robot.core.config
{
   public class ClientConfig
   {
      private static var clientXML:XML;
      
      private static var _resURL:String;
      
      private static var _moduleURL:String;
      
      private static var _taskModuleURL:String;
      
      private static var _taskItemIconURL:String;
      
      private static var _bookModuleURL:String;
      
      private static var _gameModuleURL:String;
      
      private static var _helpModuleURL:String;
      
      private static var _npcURL:String;
      
      private static var _mailTemplateURL:String;
      
      private static var _clothLightURL:String;
      
      private static var _transformURL:String;
      
      public function ClientConfig()
      {
         super();
      }
      
      public static function setup(configXML:XML) : void
      {
         ServerConfig.setup(configXML);
         clientXML = configXML;
         _resURL = clientXML.Res[0].@url.toString();
         _moduleURL = clientXML.AppModule[0].@url.toString();
         _taskModuleURL = clientXML.TaskModule[0].@url.toString();
         _taskItemIconURL = clientXML.TaskItemIconURL[0].@url.toString();
         _bookModuleURL = clientXML.BookModule[0].@url.toString();
         _gameModuleURL = clientXML.GameModule[0].@url.toString();
         _helpModuleURL = clientXML.HelpModule[0].@url.toString();
         _npcURL = configXML.Npc[0].@url.toString();
         _mailTemplateURL = clientXML.MailTemplateURL[0].@url.toString();
         _clothLightURL = clientXML.ClothLight[0].@url.toString();
         _transformURL = clientXML.Transform[0].@url.toString();
      }
      
      public static function getXmlPath(value:String) : String
      {
         return "config/" + clientXML.XML.elements(value).@path.toString();
      }
      
      public static function getUrl(value:String) : String
      {
         return clientXML.URL.elements(value).toString();
      }
      
      public static function getClothLightUrl(level:uint) : String
      {
         return _clothLightURL + "light_" + level + ".swf";
      }
      
      public static function getClothCircleUrl(level:uint) : String
      {
         var str:String = getClothLightUrl(level);
         return str.replace(/light/g,"qq");
      }
      
      public static function getTransformMovieUrl(suitID:uint) : String
      {
         return _transformURL + suitID + ".swf";
      }
      
      public static function getTransformClothUrl(suitID:uint) : String
      {
         return getTransformMovieUrl(suitID).replace(/movie\//,"swf/");
      }
      
      public static function getMailTemplateUrl(id:uint) : String
      {
         return _mailTemplateURL + id + ".swf";
      }
      
      public static function getAppExtSwf(id:String) : String
      {
         return "ext/com/robot/ext/Ext_" + id + ".swf";
      }
      
      public static function getNpcSwfPath(value:String) : String
      {
         return _npcURL + value + ".swf";
      }
      
      public static function getResPath(value:String) : String
      {
         return _resURL + value;
      }
      
      public static function getMapPath(id:uint) : String
      {
         return _resURL + "map/" + id.toString() + ".swf";
      }
      
      public static function getNonoPath(s:String) : String
      {
         return _resURL + "nono/" + s + ".swf";
      }
      
      public static function getRoomPath(id:uint) : String
      {
         return _resURL + "room/" + id.toString() + ".swf";
      }
      
      public static function getPetSwfPath(id:uint) : String
      {
         return _resURL + "pet/swf/" + id.toString() + ".swf";
      }
      
      public static function getAppModule(name:String) : String
      {
         return _moduleURL + name + ".swf";
      }
      
      public static function getTaskModule(name:String) : String
      {
         return _taskModuleURL + name + ".swf";
      }
      
      public static function getBookModule(name:String) : String
      {
         return _bookModuleURL + name + ".swf";
      }
      
      public static function getGameModule(name:String) : String
      {
         return _gameModuleURL + name + ".swf";
      }
      
      public static function getHelpModule(name:String) : String
      {
         return _helpModuleURL + name + ".swf";
      }
      
      public static function getTaskItemIcon(name:String) : String
      {
         return _taskItemIconURL + name + ".swf";
      }
      
      public static function getFitmentIcon(id:uint) : String
      {
         return _resURL + "fitment/icon/" + id.toString() + ".swf";
      }
      
      public static function getFitmentItem(id:uint) : String
      {
         return _resURL + "fitment/item/" + id.toString() + ".swf";
      }
      
      public static function getArmIcon(id:uint) : String
      {
         return _resURL + "arm/icon/" + id.toString() + ".swf";
      }
      
      public static function getArmPrev(id:String) : String
      {
         return _resURL + "arm/prev/" + id.toString() + ".swf";
      }
      
      public static function getArmItem(id:String) : String
      {
         return _resURL + "arm/item/" + id.toString() + ".swf";
      }
      
      public static function get httpURL() : String
      {
         return clientXML.ipConfig.http.@url;
      }
      
      public static function get SUB_SERVER_IP() : String
      {
         return clientXML.ipConfig.SubServer.@ip;
      }
      
      public static function get SUB_SERVER_PORT() : uint
      {
         return uint(clientXML.ipConfig.SubServer.@port);
      }
      
      public static function get EMAIL_IP() : String
      {
         return clientXML.ipConfig.Email.@ip;
      }
      
      public static function get EMAIL_PORT() : uint
      {
         return uint(clientXML.ipConfig.Email.@port);
      }
      
      public static function get ID_IP() : String
      {
         return clientXML.ipConfig.DirSer.@ip;
      }
      
      public static function get ID_PORT() : uint
      {
         return uint(clientXML.ipConfig.DirSer.@port);
      }
      
      public static function get GUEST_IP() : String
      {
         return clientXML.ipConfig.Visitor.@ip;
      }
      
      public static function get GUEST_PORT() : uint
      {
         return uint(clientXML.ipConfig.Visitor.@port);
      }
      
      public static function get REGIST_IP() : String
      {
         return clientXML.ipConfig.RegistSer.@ip;
      }
      
      public static function get REGIST_PORT() : uint
      {
         return uint(clientXML.ipConfig.RegistSer.@port);
      }
      
      public static function get maxPeople() : uint
      {
         return uint(clientXML.ServerList.@max);
      }
      
      public static function get newsVersion() : uint
      {
         return uint(clientXML.newsversion);
      }
      
      public static function get dailyTask() : uint
      {
         return uint(clientXML.dailyTask);
      }
      
      public static function get superNoNo() : uint
      {
         return uint(clientXML.superNoNo);
      }
      
      public static function get regVersion() : String
      {
         return clientXML.regversion;
      }
      
      public static function get uiVersion() : String
      {
         return clientXML.uiversion;
      }
      
      public static function get fightVersion() : String
      {
         return clientXML.fightVersion;
      }
   }
}

