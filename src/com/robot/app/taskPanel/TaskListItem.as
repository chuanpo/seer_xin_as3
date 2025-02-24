package com.robot.app.taskPanel
{
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.effect.ColorFilter;
   
   public class TaskListItem extends Sprite
   {
      private var mc:MovieClip;
      
      private var _id:uint;
      
      private var _status:uint;
      
      public function TaskListItem(taskID:uint)
      {
         var stu:uint = 0;
         super();
         this._id = taskID;
         this.mc = new ui_listItemMC();
         this.mc["bgMC"].gotoAndStop(1);
         addChild(this.mc);
         var txt:TextField = this.mc["txt"];
         txt.text = TasksXMLInfo.getName(taskID);
         this.mouseChildren = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         if(this.id == 1 || this._id == 2 || this._id == 3 || this._id == 4)
         {
            stu = uint(TasksManager.ALR_ACCEPT);
            if(TasksManager.getTaskStatus(1) == stu || TasksManager.getTaskStatus(2) == stu || TasksManager.getTaskStatus(3) == stu || TasksManager.getTaskStatus(4) == stu)
            {
               this._status = TasksManager.ALR_ACCEPT;
            }
         }
         else
         {
            this._status = TasksManager.getTaskStatus(taskID);
         }
         if(this._status == TasksManager.ALR_ACCEPT)
         {
            this.filters = [ColorFilter.setHue(180),ColorFilter.setContrast(30)];
         }
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         this.mc["bgMC"].gotoAndStop(2);
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this.mc["bgMC"].gotoAndStop(1);
      }
      
      public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.mc = null;
      }
   }
}

