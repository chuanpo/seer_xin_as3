package com.robot.app.task.taskProStep
{
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class TaskStepXMLInfo
   {
      private static var _taskStepXML:XML;
      
      private static var _dataMap:HashMap;
      
      public function TaskStepXMLInfo()
      {
         super();
      }
      
      public static function setup(xml:XML) : void
      {
         var item:XML = null;
         var id:uint = 0;
         if(xml == null)
         {
            return;
         }
         _dataMap = new HashMap();
         var xmlList:XMLList = xml.elements("pro");
         for each(item in xmlList)
         {
            id = uint(item.@id);
            _dataMap.add(id,item);
         }
      }
      
      public static function get proCnt() : uint
      {
         return _dataMap.length;
      }
      
      public static function getProDes(proID:uint) : String
      {
         var proXML:XML = _dataMap.getValue(proID);
         if(Boolean(proXML))
         {
            return String(proXML.des);
         }
         return "";
      }
      
      public static function getProMapID(proID:uint) : uint
      {
         var proXML:XML = _dataMap.getValue(proID);
         if(Boolean(proXML))
         {
            return uint(proXML.@mapID);
         }
         return 0;
      }
      
      public static function getStepList(proID:uint) : Array
      {
         var stepXml:XML = null;
         var arr:Array = [];
         var xml:XML = _dataMap.getValue(proID) as XML;
         if(xml == null)
         {
            return [];
         }
         var xmlList:XMLList = xml.step;
         for each(stepXml in xmlList)
         {
            arr.push(stepXml.@type);
         }
         return arr;
      }
      
      public static function getStepCnt(proID:uint) : uint
      {
         var xml:XML = _dataMap.getValue(proID);
         var xmlList:XMLList = xml.step;
         if(Boolean(xmlList))
         {
            return xmlList.length();
         }
         return 0;
      }
      
      public static function getStepXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = null;
         var xml:XML = _dataMap.getValue(proID);
         if(xml == null)
         {
            return null;
         }
         var xmlList:XMLList = xml.step;
         for each(stepXML in xmlList)
         {
            if(stepXML.@id == stepCnt)
            {
               return stepXML;
            }
         }
         return null;
      }
      
      public static function getStepType(proID:uint, stepCnt:uint) : String
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.@type;
      }
      
      public static function getStepGoto(proID:uint, stepCnt:uint) : Array
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         var str:String = String(stepXML["@goto"]);
         return str.split("_");
      }
      
      public static function getStepIsComplete(proID:uint, stepCnt:uint) : Boolean
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return Boolean(uint(stepXML.@isCompletePro));
      }
      
      public static function getStepOptionXML(proID:uint, stepCnt:uint, optionID:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return XML(stepXML.option[optionID]);
      }
      
      public static function getStepOptionCnt(proID:uint, stepCnt:uint) : uint
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return (stepXML.option as XMLList).length();
      }
      
      public static function getStepOptionGoto(proID:uint, stepCnt:uint, optionID:uint) : Array
      {
         var optionXML:XML = getStepOptionXML(proID,stepCnt,optionID);
         return String(optionXML["@goto"]).split("_");
      }
      
      public static function getStepOptionDes(proID:uint, stepCnt:uint, optionID:uint) : String
      {
         var optionXML:XML = getStepOptionXML(proID,stepCnt,optionID);
         return optionXML.@des;
      }
      
      public static function getStepTalkXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.talk[0];
      }
      
      public static function getStepTalkNpc(proID:uint, stepCnt:uint) : String
      {
         var talkXML:XML = getStepTalkXML(proID,stepCnt);
         if(Boolean(talkXML))
         {
            return talkXML.@npcName;
         }
         return "";
      }
      
      public static function getStepTalkMC(proID:uint, stepCnt:uint) : String
      {
         var talkXML:XML = getStepTalkXML(proID,stepCnt);
         if(Boolean(talkXML))
         {
            return talkXML.@talkMcName;
         }
         return "";
      }
      
      public static function getStepTalkDes(proID:uint, stepCnt:uint) : String
      {
         var talkStr:String = null;
         var talkXML:XML = getStepTalkXML(proID,stepCnt);
         if(Boolean(talkXML))
         {
            talkStr = String(talkXML.talkDes);
            return talkStr.replace(/#nick/g,MainManager.actorInfo.nick);
         }
         return "";
      }
      
      public static function getStepTalkFunc(proID:uint, stepCnt:uint) : String
      {
         var funcStr:String = null;
         var talkXML:XML = getStepTalkXML(proID,stepCnt);
         if(Boolean(talkXML))
         {
            return talkXML.@func;
         }
         return "";
      }
      
      public static function getStepMcXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.mc[0];
      }
      
      public static function getStepMcSparkMC(proID:uint, stepCnt:uint) : String
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         return mcXML.@sparkMC;
      }
      
      public static function getStepMcType(proID:uint, stepCnt:uint) : uint
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         return mcXML.@type;
      }
      
      public static function getStepMcName(proID:uint, stepCnt:uint) : String
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         return mcXML.@name;
      }
      
      public static function getStepMcVisible(proID:uint, stepCnt:uint) : Boolean
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         return Boolean(uint(mcXML.@visible));
      }
      
      public static function getStepMcFrame(proID:uint, stepCnt:uint) : uint
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         if(uint(mcXML.@frame) != 0)
         {
            return mcXML.@frame;
         }
         return 1;
      }
      
      public static function getStepMcFunc(proID:uint, stepCnt:uint) : String
      {
         var mcXML:XML = getStepMcXML(proID,stepCnt);
         return mcXML.@func;
      }
      
      public static function getStepSceenMovieXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.sceenMovie[0];
      }
      
      public static function getStepSmSparkMC(proID:uint, stepCnt:uint) : String
      {
         var stepSmXML:XML = getStepSceenMovieXML(proID,stepCnt);
         if(Boolean(stepSmXML))
         {
            return stepSmXML.@sparkMC;
         }
         return "";
      }
      
      public static function getStepSmPlaySceenMC(proID:uint, stepCnt:uint) : String
      {
         var stepSmXML:XML = getStepSceenMovieXML(proID,stepCnt);
         if(Boolean(stepSmXML))
         {
            return stepSmXML.@playSceenMC;
         }
         return "";
      }
      
      public static function getStepSmPlayMcFrame(proID:uint, stepCnt:uint) : uint
      {
         var stepSmXML:XML = getStepSceenMovieXML(proID,stepCnt);
         if(Boolean(stepSmXML))
         {
            return stepSmXML.@frame;
         }
         return 0;
      }
      
      public static function getStepSmPlayMcChild(proID:uint, stepCnt:uint) : String
      {
         var stepSmXML:XML = getStepSceenMovieXML(proID,stepCnt);
         if(Boolean(stepSmXML))
         {
            return stepSmXML.@childMcName;
         }
         return "";
      }
      
      public static function getStepSmFunc(proID:uint, stepCnt:uint) : String
      {
         var stepSmXML:XML = getStepSceenMovieXML(proID,stepCnt);
         if(Boolean(stepSmXML))
         {
            return stepSmXML.@func;
         }
         return "";
      }
      
      public static function getStepFullMovieXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.fullMovie[0];
      }
      
      public static function getStepFmSparkMC(proID:uint, stepCnt:uint) : String
      {
         var stepFMXML:XML = getStepFullMovieXML(proID,stepCnt);
         if(Boolean(stepFMXML))
         {
            return stepFMXML.@sparkMC;
         }
         return "";
      }
      
      public static function getStepFullMovieUrl(proID:uint, stepCnt:uint) : String
      {
         var stepFMXML:XML = getStepFullMovieXML(proID,stepCnt);
         if(Boolean(stepFMXML))
         {
            return stepFMXML.@playMovieURL;
         }
         return "";
      }
      
      public static function getStepFmFunc(proID:uint, stepCnt:uint) : String
      {
         var stepFMXML:XML = getStepFullMovieXML(proID,stepCnt);
         if(Boolean(stepFMXML))
         {
            return stepFMXML.@func;
         }
         return "";
      }
      
      public static function getStepGameXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.game[0];
      }
      
      public static function getStepGmSparkMC(proID:uint, stepCnt:uint) : String
      {
         var stepGameXML:XML = getStepGameXML(proID,stepCnt);
         if(Boolean(stepGameXML))
         {
            return stepGameXML.@sparkMC;
         }
         return "";
      }
      
      public static function getStepGameUrl(proID:uint, stepCnt:uint) : String
      {
         var stepGameXML:XML = getStepGameXML(proID,stepCnt);
         if(Boolean(stepGameXML))
         {
            return stepGameXML.@playGameURL;
         }
         return "";
      }
      
      public static function getStepGamePassFunc(proID:uint, stepCnt:uint) : String
      {
         var stepGameXML:XML = getStepGameXML(proID,stepCnt);
         if(Boolean(stepGameXML))
         {
            return stepGameXML.@passGameFunc;
         }
         return "";
      }
      
      public static function getStepGameLossFunc(proID:uint, stepCnt:uint) : String
      {
         var stepGameXML:XML = getStepGameXML(proID,stepCnt);
         if(Boolean(stepGameXML))
         {
            return stepGameXML.@loseGameFunc;
         }
         return "";
      }
      
      public static function getStepFightXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.fight[0];
      }
      
      public static function getStepFtSparkMC(proID:uint, stepCnt:uint) : String
      {
         var stepFightXML:XML = getStepFightXML(proID,stepCnt);
         if(Boolean(stepFightXML))
         {
            return stepFightXML.@sparkMC;
         }
         return "";
      }
      
      public static function getStepFtBossID(proID:uint, stepCnt:uint) : uint
      {
         var stepFightXML:XML = getStepFightXML(proID,stepCnt);
         if(Boolean(stepFightXML))
         {
            return stepFightXML.@fightBossID;
         }
         return 0;
      }
      
      public static function getStepFtBossName(proID:uint, stepCnt:uint) : String
      {
         var stepFightXML:XML = getStepFightXML(proID,stepCnt);
         if(Boolean(stepFightXML))
         {
            return stepFightXML.@fightBossName;
         }
         return "";
      }
      
      public static function getStepFtSuccessFunc(proID:uint, stepCnt:uint) : String
      {
         var stepFightXML:XML = getStepFightXML(proID,stepCnt);
         if(Boolean(stepFightXML))
         {
            return stepFightXML.@fightSuccessFunc;
         }
         return "";
      }
      
      public static function getStepFtLossFunc(proID:uint, stepCnt:uint) : String
      {
         var stepFightXML:XML = getStepFightXML(proID,stepCnt);
         if(Boolean(stepFightXML))
         {
            return stepFightXML.@fightLoseFunc;
         }
         return "";
      }
      
      public static function getStepPanelXML(proID:uint, stepCnt:uint) : XML
      {
         var stepXML:XML = getStepXML(proID,stepCnt);
         return stepXML.panel[0];
      }
      
      public static function getStepPanelSparkMC(proID:uint, stepCnt:uint) : String
      {
         var panelXML:XML = getStepPanelXML(proID,stepCnt);
         return panelXML.@sparkMC;
      }
      
      public static function getStepPanelClass(proID:uint, stepCnt:uint) : String
      {
         var panelXML:XML = getStepPanelXML(proID,stepCnt);
         return panelXML.@className;
      }
      
      public static function getStepPanelFunc(proID:uint, stepCnt:uint) : String
      {
         var panelXML:XML = getStepPanelXML(proID,stepCnt);
         return panelXML.@func;
      }
   }
}

