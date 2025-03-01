package com.robot.core.ui.skillBtn
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public class NormalSkillBtn extends Sprite
   {
      private var _mc:MovieClip;
      
      public var skillID:uint;
      
      private var currentPP:int;
      
      public function NormalSkillBtn(skillID:uint = 0, currentPP:int = -1)
      {
         super();
         this._mc = this.getMC();
         this._mc.gotoAndStop(1);
         this._mc["iconMC"].gotoAndStop(1);
         this._mc["nameTxt"].mouseEnabled = false;
         this._mc["migTxt"].mouseEnabled = false;
         this._mc["ppTxt"].mouseEnabled = false;
         addChild(this._mc);
         this.init(skillID,currentPP);
      }
      
      protected function getMC() : MovieClip
      {
         return UIManager.getMovieClip("ui_Normal_PetSkilBtn");
      }
      
      public function init(id:uint, pp:int = -1) : void
      {
         this.skillID = id;
         this.currentPP = pp;
         if(this.skillID <= 0)
         {
            return;
         }
         this._mc["nameTxt"].text = SkillXMLInfo.getName(id);
         var str:String = SkillXMLInfo.getTypeEN(id);
         this._mc["iconMC"].gotoAndStop(str);
         this._mc["migTxt"].text ="命中:" + SkillXMLInfo.getHitP(id).toString()+ "% 威力:" + SkillXMLInfo.getDamage(id).toString();
         var maxPP:String = SkillXMLInfo.getPP(id).toString();
         if(pp == -1)
         {
            this._mc["ppTxt"].text = "PP:" + maxPP + "/" + maxPP;
         }
         else
         {
            this._mc["ppTxt"].text = "PP:" + pp.toString() + "/" + maxPP;
         }
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function get mc() : Sprite
      {
         return this._mc;
      }
      
      public function setSelect(b:Boolean) : void
      {
         if(b)
         {
            this._mc.gotoAndStop(2);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      public function clear() : void
      {
         this._mc["iconMC"].gotoAndStop(1);
         this._mc["nameTxt"].text = "";
         this._mc["migTxt"].text = "";
         this._mc["ppTxt"].text = "";
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function destroy() : void
      {
         this.clear();
         DisplayUtil.removeForParent(this);
         this._mc = null;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         SkillInfoTip.show(this.skillID);
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         SkillInfoTip.hide();
      }
   }
}

