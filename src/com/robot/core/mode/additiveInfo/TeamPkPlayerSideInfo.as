package com.robot.core.mode.additiveInfo
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.teamPK.TeamPKManager;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamPkPlayerSideInfo implements ISpriteAdditiveInfo
   {
      private var model:BasePeoleModel;
      
      private var q_mc:MovieClip;
      
      private var type:uint;
      
      public function TeamPkPlayerSideInfo(model:BasePeoleModel)
      {
         super();
         this.model = model;
      }
      
      public function get side() : uint
      {
         return this.type;
      }
      
      public function set info(info:Object) : void
      {
         this.type = uint(info);
         if(Boolean(this.q_mc))
         {
            DisplayUtil.removeForParent(this.q_mc);
         }
         if(this.type == TeamPKManager.HOME)
         {
            this.q_mc = new red_q();
         }
         else
         {
            this.q_mc = new blue_q();
         }
         this.model.addChildAt(this.q_mc,0);
         if(this.model == MainManager.actorModel)
         {
            this.model.swapChildren(ActorModel(this.model).footMC,this.q_mc);
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.q_mc);
      }
   }
}

