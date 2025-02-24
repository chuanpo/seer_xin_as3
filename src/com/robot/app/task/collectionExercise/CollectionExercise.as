package com.robot.app.task.collectionExercise
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.AppModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class CollectionExercise
   {
      private static var icon:MovieClip;
      
      private static var panel:AppModel;
      
      public static const TASK_ID:uint = 17;
      
      public function CollectionExercise()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            showIcon();
            onAccept(true);
         }
      }
      
      public static function start() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(TASK_ID,onAccept);
         }
         else if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            isGetRes();
         }
      }
      
      private static function isGetRes() : void
      {
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,getCollection);
         ItemManager.getCollection();
      }
      
      private static function getCollection(e:ItemEvent) : void
      {
         var j:int = 0;
         var str:String = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,getCollection);
         if(Boolean(ItemManager.getCollectionInfo(400001)))
         {
            j = int(ItemManager.getCollectionInfo(400001).itemNum);
            if(j >= 10)
            {
               str = "那么快就采集完了吗？嗯，就是我要的矿石。干得好，感谢你为赛尔号做出的贡献！";
               NpcTipDialog.show(str,function():void
               {
                  TasksManager.complete(TASK_ID,0);
               },NpcTipDialog.CICI);
            }
            else
            {
               str = "还没有采集到我要的矿石吗？细心些，找找看哪些星球上有黄晶矿石，记得要带上钻头啊！";
               NpcTipDialog.show(str,null,NpcTipDialog.CICI);
            }
         }
         else
         {
            str = "还没有采集到我要的矿石吗？细心些，找找看哪些星球上有黄晶矿石，记得要带上钻头啊！";
            NpcTipDialog.show(str,null,NpcTipDialog.CICI);
         }
      }
      
      private static function showIcon() : void
      {
         if(!icon)
         {
            icon = UIManager.getMovieClip("CollectionExercisICON");
            icon.light_mc.mouseChildren = false;
            icon.light_mc.mouseEnabled = false;
            ToolTipManager.add(icon,TasksXMLInfo.getName(TASK_ID));
         }
         TaskIconManager.addIcon(icon);
         icon.addEventListener(MouseEvent.CLICK,clickHandler);
         lightIcon();
      }
      
      public static function lightIcon() : void
      {
         icon.light_mc.gotoAndPlay(1);
         icon.light_mc.visible = true;
      }
      
      private static function noLightIcon() : void
      {
         icon.light_mc.gotoAndStop(1);
         icon.light_mc.visible = false;
      }
      
      private static function clickHandler(e:MouseEvent) : void
      {
         noLightIcon();
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("CollectionExercisPanel"),"正在打开任务信息");
            panel.setup();
         }
         panel.show();
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(icon);
         ToolTipManager.remove(icon);
      }
      
      public static function onAccept(b:Boolean) : void
      {
         var str:String = null;
         var npc:String = null;
         getTool();
      }
      
      public static function getTool() : void
      {
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,onClothList);
         ItemManager.getCloth();
      }
      
      private static function onClothList(event:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onClothList);
         var hasCloseB:Boolean = false;
         var hasMaozi:Boolean = false;
         var array:Array = ItemManager.getClothIDs();
         for(var i:int = 0; i < array.length; i++)
         {
            if(array[i] == 100014)
            {
               hasCloseB = true;
            }
            if(array[i] == 100015)
            {
               hasMaozi = true;
            }
         }
         if(!hasCloseB)
         {
            ItemAction.buyItem(100014,false);
         }
         if(!hasMaozi)
         {
            ItemAction.buyItem(100015,false);
         }
      }
   }
}

