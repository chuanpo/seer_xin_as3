package com.robot.core.info.team
{
   import com.robot.core.info.UserInfo;
   import flash.utils.IDataInput;
   
   public class TeamMemberInfo extends UserInfo
   {
      public var priv:uint;
      
      public var contribute:uint;
      
      public function TeamMemberInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            userID = data.readUnsignedInt();
            this.priv = data.readUnsignedInt();
            this.contribute = data.readUnsignedInt();
         }
      }
   }
}

