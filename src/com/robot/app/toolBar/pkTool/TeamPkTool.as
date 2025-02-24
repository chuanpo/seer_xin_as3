package com.robot.app.toolBar.pkTool
{
   import com.robot.core.event.TeamPKEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.teamPK.TeamPKManager;
   import flash.events.MouseEvent;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.UIMovieClip;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.effect.ColorFilter;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamPkTool
   {
      private static var _instance:TeamPkTool;
      
      private var box:HBox;
      
      private var currentMouseIcon:IPKMouseIcon;
      
      private var mouseIconList:Array;
      
      public function TeamPkTool()
      {
         var i:IPKMouseIcon = null;
         this.mouseIconList = [];
         super();
         this.box = new HBox(15);
         this.box.height = 80;
         this.box.width = MainManager.getStageWidth() - 85;
         this.box.halign = FlowLayout.RIGHT;
         this.box.valign = FlowLayout.MIDLLE;
         this.mouseIconList.push(new ShotMouseIcon(),new PetFightMouseIcon(),new ShieldMouseIcon());
         for each(i in this.mouseIconList)
         {
            i.addEventListener(MouseEvent.CLICK,this.clickIcon);
            this.box.append(new UIMovieClip(i.sprite));
         }
         TeamPKManager.addEventListener(TeamPKEvent.CLOSE_TOOL,this.onToolHandler);
         TeamPKManager.addEventListener(TeamPKEvent.OPEN_TOOL,this.onToolHandler);
      }
      
      public static function get instance() : TeamPkTool
      {
         if(!_instance)
         {
            _instance = new TeamPkTool();
         }
         return _instance;
      }
      
      private function onToolHandler(event:TeamPKEvent) : void
      {
         if(event.type == TeamPKEvent.CLOSE_TOOL)
         {
            this.close();
         }
         else
         {
            this.open();
         }
      }
      
      public function show() : void
      {
         var i:IPKMouseIcon = null;
         this.box.y = MainManager.getStageHeight() - 140;
         LevelManager.toolsLevel.addChild(this.box);
         for each(i in this.mouseIconList)
         {
            i.reset();
         }
      }
      
      public function close() : void
      {
         this.box.mouseChildren = false;
         this.box.filters = [ColorFilter.setGrayscale()];
      }
      
      public function open() : void
      {
         this.box.mouseChildren = true;
         this.box.filters = [];
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.box);
      }
      
      public function destroy() : void
      {
         this.hide();
         this.box.destroy();
         this.box = null;
         this.currentMouseIcon.destroy();
         this.currentMouseIcon = null;
      }
      
      private function clickIcon(event:MouseEvent) : void
      {
         this.currentMouseIcon = event.currentTarget as IPKMouseIcon;
         this.currentMouseIcon.show();
      }
   }
}

