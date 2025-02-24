package com.robot.core.mode
{
   import com.robot.core.info.NonoInfo;
   import com.robot.core.info.UserInfo;
   
   public class PeopleModel extends BasePeoleModel
   {
      public function PeopleModel(info:UserInfo)
      {
         var nonoInfo:NonoInfo = null;
         super(info);
         if(Boolean(info.nonoState[1]))
         {
            nonoInfo = new NonoInfo();
            nonoInfo.userID = info.userID;
            nonoInfo.color = info.nonoColor;
            nonoInfo.superStage = info.vipStage;
            nonoInfo.nick = info.nonoNick;
            nonoInfo.superNono = info.superNono;
            showNono(nonoInfo,info.actionType);
         }
      }
   }
}

