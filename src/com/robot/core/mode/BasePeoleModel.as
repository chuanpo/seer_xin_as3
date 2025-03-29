package com.robot.core.mode
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.AimatAction;
   import com.robot.core.aticon.ChatAction;
   import com.robot.core.aticon.FigureAction;
   import com.robot.core.aticon.PeculiarAction;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.item.DoodleInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.info.team.ITeamLogoInfo;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.additiveInfo.ISpriteAdditiveInfo;
   import com.robot.core.mode.additiveInfo.TeamPkPlayerSideInfo;
   import com.robot.core.mode.spriteInteractive.ClothLightInteractive;
   import com.robot.core.mode.spriteInteractive.ISpriteInteractiveAction;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.EmptySkeletonStrategy;
   import com.robot.core.skeleton.ISkeleton;
   import com.robot.core.skeleton.TransformSkeleton;
   import com.robot.core.teamInstallation.TeamLogo;
   import com.robot.core.utils.Direction;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="walkEnterFrame",type="com.robot.core.event.RobotEvent")]
   [Event(name="walkEnd",type="com.robot.core.event.RobotEvent")]
   [Event(name="walkStart",type="com.robot.core.event.RobotEvent")]
   [Event(name="changeDirection",type="com.robot.core.event.RobotEvent")]
   public class BasePeoleModel extends BobyModel implements ISkeletonSprite
   {
      public static var SPECIAL_ACTION:String = "action";
      
      public var isShield:Boolean = false;
      
      protected var _info:UserInfo;
      
      protected var tf:TextFormat;
      
      protected var _nameTxt:TextField;
      
      protected var _isProtected:Boolean = false;
      
      protected var _protectMC:MovieClip;
      
      protected var _skeletonSys:ISkeleton;
      
      protected var _oldSkeleton:ISkeleton;
      
      protected var _teamLogo:TeamLogo;
      
      protected var _interactiveAction:ISpriteInteractiveAction;
      
      private var _nono:INonoModel;
      
      private var _pet:PetModel;
      
      private var _tranMC:MovieClip;
      
      protected var clickBtn:Sprite;
      
      private var shieldMC:MovieClip;
      
      private var shieldTimer:Timer;
      
      private var _additiveInfo:ISpriteAdditiveInfo;
      
      private var clothLight:MovieClip;
      
      public function BasePeoleModel(info:UserInfo)
      {
         var pinfo:PetShowInfo = null;
         super();
         this._info = info;
         mouseEnabled = false;
         name = "BasePeoleModel_" + this._info.userID.toString();
         this.tf = new TextFormat();
         this.tf.font = "宋体";
         this.tf.letterSpacing = 0.5;
         this.tf.size = 12;
         this.tf.align = TextFormatAlign.CENTER;
         this._nameTxt = new TextField();
         this._nameTxt.mouseEnabled = false;
         this._nameTxt.autoSize = TextFieldAutoSize.CENTER;
         this._nameTxt.width = 100;
         this._nameTxt.height = 30;
         this._nameTxt.x = this.nameTxt.width / 2 - 4;
         this._nameTxt.y = 14;
         this._nameTxt.text = this._info.nick;
         this._nameTxt.setTextFormat(this.tf);
         addChild(UIManager.getMovieClip("show_mc"));
         addChild(this._nameTxt);
         this.skeleton = new EmptySkeletonStrategy();
         if(info.changeShape != 0)
         {
            this.skeleton = new TransformSkeleton();
         }
         pos = this._info.pos;
         this.direction = Direction.indexToStr(this._info.direction);
         if(this._info.action > 10000)
         {
            this.peculiarAction(direction,false);
         }
         if(this._info.spiritID != 0)
         {
            pinfo = new PetShowInfo();
            pinfo.catchTime = this._info.spiritTime;
            pinfo.petID = this._info.spiritID;
            pinfo.userID = this._info.userID;
            pinfo.dv = this._info.petDV;
            pinfo.shiny = this._info.petShiny;
            pinfo.skinID = this._info.petSkin;
            this.showPet(pinfo);
         }
         this.clickBtn = new Sprite();
         this.clickBtn.graphics.beginFill(0,0);
         this.clickBtn.graphics.drawRect(0,0,40,50);
         this.clickBtn.graphics.endFill();
         this.clickBtn.buttonMode = true;
         this.clickBtn.x = -20;
         this.clickBtn.y = -50;
         addChild(this.clickBtn);
         this._additiveInfo = new TeamPkPlayerSideInfo(this);
         this.interactiveAction = new ClothLightInteractive(this);
         this.addEvent();
      }
      
      public function showClothLight(isRemove:Boolean = false) : void
      {
         if(isRemove)
         {
            DisplayUtil.removeForParent(this.clothLight);
            return;
         }
         DisplayUtil.removeForParent(this.clothLight);
         var max:uint = this.info.clothMaxLevel;
         if(max > 1)
         {
            ResourceManager.getResource(ClientConfig.getClothLightUrl(max),this.onLoadLight);
         }
      }
      
      private function onLoadLight(o:DisplayObject) : void
      {
         this.clothLight = o as MovieClip;
         this.addChild(this.clothLight);
      }
      
      public function addProtectMC() : void
      {
         if(!this._protectMC)
         {
            this._protectMC = this.getProtectMC();
         }
         if(!DisplayUtil.hasParent(this._protectMC))
         {
            this._protectMC.gotoAndStop(1);
            addChild(this._protectMC);
         }
         this._isProtected = true;
      }
      
      public function aimatAction(itemID:uint, type:uint, pos:Point, isNet:Boolean = true) : void
      {
         if(isNet)
         {
            SocketConnection.send(CommandID.AIMAT,itemID,type,pos.x,pos.y);
         }
         else
         {
            this.stop();
            AimatAction.execute(itemID,type,this._info.userID,this,pos);
         }
      }
      
      override public function aimatState(info:AimatInfo) : void
      {
         if(this._isProtected)
         {
            this._protectMC.gotoAndPlay(2);
            return;
         }
         super.aimatState(info);
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 20;
         return _centerPoint;
      }
      
      public function set interactiveAction(i:ISpriteInteractiveAction) : void
      {
         if(Boolean(this._interactiveAction))
         {
            this._interactiveAction.destroy();
         }
         if(i == null)
         {
            this._interactiveAction = new ClothLightInteractive(this);
         }
         else
         {
            this._interactiveAction = i;
         }
      }
      
      public function changeCloth(clothArray:Array, isNet:Boolean = true) : void
      {
         new FigureAction().changeCloth(this,clothArray,isNet);
      }
      
      public function changeColor(color:uint, isNet:Boolean = true) : void
      {
         new FigureAction().changeColor(this,color,isNet);
      }
      
      public function changeDoodle(df:DoodleInfo, isNet:Boolean = true) : void
      {
         new FigureAction().changeDoodle(this,df,isNet);
      }
      
      public function changeNickName(nick:String, isNet:Boolean = true) : void
      {
         new FigureAction().changeNickName(this,nick,isNet);
         if(!isNet)
         {
            this._nameTxt.text = nick;
            this._nameTxt.setTextFormat(this.tf);
         }
      }
      
      public function chatAction(msg:String, toID:uint = 0, isNet:Boolean = true) : void
      {
         new ChatAction().execute(this,msg,toID,isNet);
      }
      
      public function delProtectMC() : void
      {
         DisplayUtil.removeForParent(this._protectMC,false);
         this._isProtected = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
         this.hidePet();
         this.hideNono();
         this._pet = null;
         DisplayUtil.removeForParent(this);
         this._info = null;
         this._skeletonSys = null;
         DisplayUtil.removeForParent(this._protectMC);
         this._protectMC = null;
         if(Boolean(this._teamLogo))
         {
            this._teamLogo.destroy();
         }
         this._teamLogo = null;
         if(Boolean(this._interactiveAction))
         {
            this._interactiveAction.destroy();
            this._interactiveAction = null;
         }
         DisplayUtil.removeForParent(this.clothLight);
         this.clothLight = null;
      }
      
      override public function set direction(dir:String) : void
      {
         if(dir == null || dir == "")
         {
            return;
         }
         _direction = dir;
         this._skeletonSys.changeDirection(dir);
         dispatchEvent(new DynamicEvent(RobotEvent.CHANGE_DIRECTION,dir));
      }
      
      public function get skeleton() : ISkeleton
      {
         return this._skeletonSys;
      }
      
      override public function get height() : Number
      {
         return this._skeletonSys.getBodyMC().height;
      }
      
      public function hideNono() : void
      {
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      public function hidePet() : void
      {
         if(Boolean(this._pet))
         {
            this._pet.destroy();
            this._pet = null;
         }
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x + this.clickBtn.x;
         _hitRect.y = y + this.clickBtn.y;
         _hitRect.width = 35;
         _hitRect.height = 40;
         return _hitRect;
      }
      
      public function get nameTxt() : TextField
      {
         return this._nameTxt;
      }
      
      public function get info() : UserInfo
      {
         return this._info;
      }
      
      public function get additiveInfo() : ISpriteAdditiveInfo
      {
         return this._additiveInfo;
      }
      
      public function get isTransform() : Boolean
      {
         return this._skeletonSys is TransformSkeleton;
      }
      
      public function get isProtected() : Boolean
      {
         return this._isProtected;
      }
      
      public function get nono() : INonoModel
      {
         return this._nono;
      }
      
      public function peculiarAction(dir:String = "", isNet:Boolean = true) : void
      {
         new PeculiarAction().execute(this,dir,isNet);
      }
      
      public function get pet() : PetModel
      {
         return this._pet;
      }
      
      public function removeTeamLogo() : void
      {
         DisplayUtil.removeForParent(this._teamLogo,false);
      }
      
      public function set skeleton(i:ISkeleton) : void
      {
         if(Boolean(this._skeletonSys))
         {
            this._oldSkeleton = this._skeletonSys;
         }
         this._skeletonSys = i;
         this._skeletonSys.people = this;
         this._skeletonSys.info = this._info;
      }
      
      public function clearOldSkeleton() : void
      {
         if(Boolean(this._oldSkeleton))
         {
            this._oldSkeleton.destroy();
            this._oldSkeleton = null;
         }
      }
      
      public function showNono(info:NonoInfo, type:uint = 0) : void
      {
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
         if(info.superStage == 0)
         {
            info.superStage = 1;
         }
         if(type == 0)
         {
            this._nono = new NonoModel(info,this);
         }
         else
         {
            this._nono = new NonoFlyModel(info,this);
         }
      }
      
      public function showNonoShield(time:uint) : void
      {
         if(!this.shieldTimer)
         {
            this.shieldTimer = new Timer(time * 1000,1);
            this.shieldTimer.addEventListener(TimerEvent.TIMER,this.onShieldTimer);
         }
         this.shieldTimer.reset();
         this.shieldTimer.start();
         this.isShield = true;
         if(!this.shieldMC)
         {
            this.shieldMC = ShotBehaviorManager.getMovieClip("pk_nono_shield");
         }
         this.shieldMC.gotoAndStop(1);
         addChild(this.shieldMC);
      }
      
      public function showPet(info:PetShowInfo) : void
      {
         if(this._pet == null)
         {
            this._pet = new PetModel(this);
         }
         this._pet.show(info);
      }
      
      public function showShieldMovie() : void
      {
         this.shieldMC.gotoAndPlay(2);
      }
      
      public function showTeamLogo(info:ITeamLogoInfo) : void
      {
         if(info is SimpleTeamInfo)
         {
            if(SimpleTeamInfo(info).superCoreNum < 10)
            {
               return;
            }
         }
         if(!this._teamLogo)
         {
            this._teamLogo = new TeamLogo();
         }
         this._teamLogo.info = info;
         this._teamLogo.scaleY = 0.6;
         this._teamLogo.scaleX = 0.6;
         this._teamLogo.x = -this._teamLogo.width / 2;
         this._teamLogo.y = -60 - this._teamLogo.height * this._teamLogo.scaleX - 5;
         addChild(this._teamLogo);
      }
      
      public function specialAction(id:uint) : void
      {
         this._skeletonSys.specialAction(this,id);
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(this._pet))
         {
            this._pet.stop();
         }
      }
      
      public function stopSpecialAct() : void
      {
         this.direction = Direction.DOWN;
      }
      
      public function takeOffCloth() : void
      {
         this._skeletonSys.takeOffCloth();
      }
      
      public function walkAction(data:Object, isNet:Boolean = true) : void
      {
         _walk.execute(this,data,isNet);
      }
      
      override public function get width() : Number
      {
         return this._skeletonSys.getBodyMC().width;
      }
      
      protected function addEvent() : void
      {
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         this.clickBtn.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.clickBtn.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.clickBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         UserManager.addActionListener(this._info.userID,this.onAction);
         addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
      }
      
      protected function onWalkEnd(e:Event) : void
      {
         this._skeletonSys.stop();
      }
      
      private function getProtectMC() : MovieClip
      {
         var mc:MovieClip = UIManager.getMovieClip("ui_TandS_Protecte_MC");
         mc.mouseChildren = false;
         mc.mouseEnabled = false;
         return mc;
      }
      
      private function hideShield() : void
      {
         this.isShield = false;
         DisplayUtil.removeForParent(this.shieldMC,false);
      }
      
      private function onAction(e:PeopleActionEvent) : void
      {
         var type:uint = 0;
         var nonoInfo:NonoInfo = null;
         switch(e.actionType)
         {
            case PeopleActionEvent.WALK:
               this.walkAction(e.data,false);
               break;
            case PeopleActionEvent.CHAT:
               this.chatAction(e.data as String,0,false);
               break;
            case PeopleActionEvent.COLOR_CHANGE:
               this._info.coins = e.data.coins as uint;
               this.changeColor(e.data.color,false);
               break;
            case PeopleActionEvent.CLOTH_CHANGE:
               this.changeCloth(e.data as Array,false);
               break;
            case PeopleActionEvent.DOODLE_CHANGE:
               this.changeDoodle(e.data as DoodleInfo,false);
               break;
            case PeopleActionEvent.PET_SHOW:
               this.showPet(e.data as PetShowInfo);
               break;
            case PeopleActionEvent.PET_HIDE:
               this.hidePet();
               break;
            case PeopleActionEvent.NAME_CHANGE:
               this.changeNickName(e.data.nickName,false);
               break;
            case PeopleActionEvent.AIMAT:
               type = e.data.type as uint;
               if(type > 10000)
               {
                  if(AimatXMLInfo.getType(this._info.clothIDs) == 0)
                  {
                     return;
                  }
               }
               this.aimatAction(e.data.itemID,type,e.data.pos as Point,false);
               break;
            case PeopleActionEvent.SPECIAL:
               this.peculiarAction(e.data as String,false);
               break;
            case PeopleActionEvent.NONO_FOLLOW:
               nonoInfo = e.data as NonoInfo;
               this.showNono(nonoInfo);
               break;
            case PeopleActionEvent.NONO_HOOM:
               this.hideNono();
         }
      }
      
      private function onShieldTimer(event:TimerEvent) : void
      {
         this.hideShield();
      }
      
      private function onWalkEnterFrame(e:Event) : void
      {
      }
      
      private function onWalkStart(e:Event) : void
      {
         this._skeletonSys.play();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         this.clickBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         UserManager.removeActionListener(this._info.userID,this.onAction);
         removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
      }
      
      private function onRollOver(event:MouseEvent) : void
      {
         this._interactiveAction.rollOver();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this._interactiveAction.rollOut();
      }
      
      private function onClick(e:MouseEvent) : void
      {
         this._interactiveAction.click();
      }
   }
}

