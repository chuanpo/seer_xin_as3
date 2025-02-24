package com.robot.core.teamInstallation
{
   import com.robot.core.info.team.ITeamLogoInfo;
   import com.robot.core.manager.TaskIconManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamLogo extends Sprite
   {
      private var sprite:Sprite;
      
      public var teamID:uint;
      
      private var _info:ITeamLogoInfo;
      
      public function TeamLogo()
      {
         super();
         this.sprite = new Sprite();
         this.sprite.mouseChildren = false;
         this.sprite.graphics.beginFill(0,0);
         this.sprite.graphics.drawRect(0,0,72,72);
         addChild(this.sprite);
      }
      
      public function set info(v:ITeamLogoInfo) : void
      {
         var bgMC:MovieClip = null;
         this.teamID = v.teamID;
         this._info = v;
         DisplayUtil.removeAllChild(this.sprite);
         var word:String = v.logoWord;
         if(v.logoBg != 10000)
         {
            bgMC = TaskIconManager.getIcon("icon_bg_" + v.logoBg) as MovieClip;
            this.alignIcon(bgMC);
            this.sprite.addChild(bgMC);
         }
         var iconMC:MovieClip = TaskIconManager.getIcon("icon_" + v.logoIcon) as MovieClip;
         var colorMC:MovieClip = iconMC["colorMC"];
         DisplayUtil.FillColor(colorMC,v.logoColor);
         var txt_mc:MovieClip = new txtMC();
         var txt:TextField = txt_mc["txt"];
         txt.textColor = v.txtColor;
         txt.text = word;
         txt.selectable = false;
         iconMC.addChild(txt_mc);
         DisplayUtil.align(txt_mc,colorMC.getRect(iconMC),AlignType.MIDDLE_CENTER);
         if(Boolean(bgMC))
         {
            bgMC.addChild(iconMC);
         }
         else
         {
            this.alignIcon(iconMC);
            this.sprite.addChild(iconMC);
         }
      }
      
      private function alignIcon(icon:DisplayObject) : void
      {
         var rect:Rectangle = icon.getRect(icon);
         icon.x = (this.sprite.width - icon.width) / 2 - rect.x;
         icon.y = (this.sprite.height - icon.height) / 2 - rect.y;
      }
      
      public function destroy() : void
      {
         this.sprite = null;
      }
      
      public function clone() : TeamLogo
      {
         var logo:TeamLogo = new TeamLogo();
         logo.info = this._info;
         return logo;
      }
   }
}

