package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamInfo
   {
      public var id:uint;
      
      public var level:uint;
      
      public var priv:uint;
      
      public var superCore:Boolean;
      
      public var coreCount:uint;
      
      public var isShow:Boolean;
      
      public var logoBg:uint;
      
      public var logoIcon:uint;
      
      public var logoColor:uint;
      
      public var txtColor:uint;
      
      public var logoWord:String;
      
      public var allContribution:uint;
      
      public var canExContribution:uint;
      
      public function TeamInfo(data:IDataInput = null)
      {
         super();
         if(!data)
         {
            return;
         }
         this.id = data.readUnsignedInt();
         this.priv = data.readUnsignedInt();
         this.superCore = Boolean(data.readUnsignedInt());
         this.isShow = Boolean(data.readUnsignedInt());
         this.allContribution = data.readUnsignedInt();
         this.canExContribution = data.readUnsignedInt();
      }
   }
}

