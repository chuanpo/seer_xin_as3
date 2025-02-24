package com.robot.core.display.tree
{
   import com.robot.core.effect.GlowTween;
   import com.robot.core.manager.TasksManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.manager.ResourceManager;
   
   public class TreeItem extends Sprite
   {
      private static var glowTween:GlowTween;
      
      private static var _addGlow:Boolean = false;
      
      public function TreeItem()
      {
         super();
      }
      
      private static function setTaskState(nodedata:*, mc:MovieClip) : void
      {
         var index:uint = 0;
         if(nodedata.isVip == "1")
         {
            index = 4;
         }
         if(TasksManager.getTaskStatus(uint(nodedata.id)) == TasksManager.COMPLETE)
         {
            mc["taskstate"].gotoAndStop(4 + index);
         }
         else if(nodedata.newOnline == "1")
         {
            if(TasksManager.getTaskStatus(uint(nodedata.id)) == TasksManager.ALR_ACCEPT)
            {
               mc["taskstate"].gotoAndStop(2 + index);
            }
            else
            {
               mc["taskstate"].gotoAndStop(1 + index);
            }
         }
         else if(nodedata.offline == "1")
         {
            mc["taskstate"].gotoAndStop(3 + index);
         }
         else if(TasksManager.getTaskStatus(uint(nodedata.id)) == TasksManager.UN_ACCEPT)
         {
            mc["taskstate"].gotoAndStop(9);
         }
         else
         {
            mc["taskstate"].gotoAndStop(2 + index);
         }
      }
      
      public static function createItem(nodedata:*, addGlow:Boolean) : MovieClip
      {
         var itemmenu:MovieClip = null;
         _addGlow = addGlow;
         switch(uint(nodedata.itemtype))
         {
            case 1:
               itemmenu = new item1();
               break;
            case 2:
               itemmenu = new item2();
               break;
            case 3:
               itemmenu = new item3();
               setInfo3(itemmenu,nodedata);
               break;
            case 4:
               itemmenu = new item4();
               setInfo4(itemmenu,nodedata);
               setTaskState(nodedata,itemmenu);
               break;
            case 5:
               itemmenu = new item5();
               setInfo5(itemmenu,nodedata);
               setTaskState(nodedata,itemmenu);
               break;
            default:
               itemmenu = new item5();
               setInfo5(itemmenu,nodedata);
         }
         (itemmenu["bg"] as MovieClip).gotoAndStop(1);
         return itemmenu;
      }
      
      private static function setInfo3(btn:MovieClip, data:*) : void
      {
         getStarIconByID(data.starid,btn["icon"] as MovieClip);
         (btn["bg"] as MovieClip).gotoAndStop(1);
         (btn["titlename"] as TextField).htmlText = data.name;
         (btn["star"] as MovieClip).gotoAndStop(uint(data.starlevel) + 1);
         (btn["leveltxt"] as TextField).htmlText = data.spanlevel;
         if(_addGlow)
         {
            btn["tip_mc"].visible = true;
         }
         else
         {
            btn["tip_mc"].visible = false;
         }
      }
      
      private static function setInfo4(btn:MovieClip, data:*) : void
      {
         makeTaskIcon(data.id,btn["icon"] as MovieClip);
         (btn["titletxt"] as TextField).htmlText = data.name;
         (btn["star"] as MovieClip).gotoAndStop(uint(data.starlevel) + 1);
         (btn["taskstate"] as MovieClip).gotoAndStop(1);
      }
      
      private static function setInfo5(btn:MovieClip, data:*) : void
      {
         makeTaskIcon(data.id,btn["icon"] as MovieClip);
         (btn["titletxt"] as TextField).htmlText = data.name;
      }
      
      public static function getStarIconByID(id:String, iconContainer:MovieClip) : void
      {
         var _url:String;
         iconContainer.scaleX = 1;
         iconContainer.scaleY = 1;
         _url = "resource/planet/icon/" + id + ".swf";
         ResourceManager.getResource(_url,function(mc:DisplayObject):void
         {
            var _icon:MLoadPane = null;
            if(Boolean(mc))
            {
               _icon = new MLoadPane(mc);
               if(mc.width > mc.height)
               {
                  _icon.fitType = MLoadPane.FIT_WIDTH;
               }
               else
               {
                  _icon.fitType = MLoadPane.FIT_HEIGHT;
               }
               _icon.setSizeWH(40,40);
               iconContainer.addChild(_icon);
            }
         },"star");
      }
      
      private static function makeTaskIcon(taskID:String, iconContainer:MovieClip) : void
      {
         var url:String = "resource/task/icon/" + taskID + ".swf";
         ResourceManager.getResource(url,function(mc:DisplayObject):void
         {
            if(Boolean(mc))
            {
               mc.scaleX = 0.5;
               mc.scaleY = 0.5;
               iconContainer.addChild(mc);
            }
         },"item");
      }
   }
}

