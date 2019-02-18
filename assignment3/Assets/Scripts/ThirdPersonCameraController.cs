using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityStandardAssets.ImageEffects;
using UnityStandardAssets.Utility;

public class ThirdPersonCameraController : MonoBehaviour {

    #region Internal References
    private Transform _app;
    private Transform _view;
    private Transform _cameraBaseTransform;
    private Transform _cameraTransform;
    private Transform _cameraLookTarget;
    private Transform _cameraRotateTarget;
    private Transform _avatarTransform;
    private Rigidbody _avatarRigidbody;
    #endregion

    #region Public Tuning Variables
    public Vector3 avatarObservationOffset_Base;
    public float followDistance_Base;
    public float verticalOffset_Base;
    public float pitchGreaterLimit;
    public float pitchLowerLimit;
    public float fovAtUp;
    public float fovAtDown;
    public float fov_Base;
    public Camera Camera;
    #endregion

    
    #region Persistent Outputs
    //Positions
    private Vector3 _camRelativePostion_Auto;

    //Directions
    private Vector3 _avatarLookForward;

    //Scalars
    private float _followDistance_Applied;
    private float _verticalOffset_Applied;
    private float _fieldOfView_Applied;

    
    //States
    private CameraStates _currentState;
    #endregion

    private void Start()
    {
        _currentState = CameraStates.Automatic;
        Camera.main.fieldOfView = fov_Base;
        
        Vector3 _camEulerHold = _cameraTransform.eulerAngles;
        x = _camEulerHold.y;
        y = _camEulerHold.x;
    }
    
    
    private void Awake()
    {
        _app = GameObject.Find("Application").transform;
        _view = _app.Find("View");
        _cameraBaseTransform = _view.Find("CameraBase");
        _cameraTransform = _cameraBaseTransform.Find("Camera");
        _cameraLookTarget = _cameraBaseTransform.Find("CameraLookTarget");
        _cameraRotateTarget = _cameraBaseTransform.Find("CameraRotateTarget");

        _avatarTransform = _view.Find("AIThirdPersonController");
        _avatarRigidbody = _avatarTransform.GetComponent<Rigidbody>();

        //camera collision
        //dollyDir = _cameraTransform.localPosition.normalized;
        distance = _cameraTransform.localPosition.magnitude;
    }

    private float _idleTimer;  
   
    private void Update()
    {
        Camera.main.fieldOfView = fov_Base;
        
        //deciding when in which state
        if (Input.GetMouseButton(1))
        {
            _currentState = CameraStates.Manual;
        }
        else if (!Input.GetMouseButton(1) && _idleTimer > 1)
        {
            _currentState = CameraStates.Idle;
        }
        else
        {_currentState = CameraStates.Automatic;}

        //what should the camera do under each state
        if (_currentState == CameraStates.Automatic)
        {
            _AutoUpdate();//which contains moving the camera from walking to standing to walking
        }
        else if (_currentState == CameraStates.Manual)
        {
            _ManualUpdate();
        }
        else{_IdleUpdate();}
        print("idleTimer = " + _idleTimer);
        
        _Spherecast();
        
        
        RaycastHit hit;
        Debug.DrawRay(_cameraRotateTarget.position, _cameraTransform.TransformDirection(Vector3.back), Color.green);
//在所有情况下都不会有物体挡在相机前面
        followDistance_Base = distance;
        if (Physics.Linecast(_cameraRotateTarget.position, _cameraTransform.TransformDirection(Vector3.back), out hit))
        {
            // distance = hit.distance;
            distance = Mathf.Clamp(hit.distance * 0.8f, minDistance, maxDistance);
            // if (distance > 2)
            // {
            //    distance = 2;
            // }
            //  if (distance < 2)
            //  {
            //      distance = 2;
            //  }
              
                
        }
        else
        {
            distance = maxDistance;
        }
       // _Raycast();
        
//        if (Input.GetMouseButton(1))
//            _ManualUpdate();
//        else
//            _AutoUpdate();
    }

    #region States
    


    private int TimerLookAtOOI;
private bool runWatch = false;
private bool up = true;
    private float SlerpTime=0;

    private void _AutoUpdate()
    {
        _ComputeData();

        if (_Helper_IsThereOOI())
        {
            TimerLookAtOOI = 100;
        }

        if (TimerLookAtOOI > 0)
        {
            _LookAtObject(_Helper_WhatIsClosestOOI());
        }
        else
        {
            //if(Input.GetKeyDown("space"))
            //{
                print("space key was pressed");//按空格交互
                
                Ray ray = new Ray(_avatarTransform.position, _avatarLookForward);
                Debug.DrawRay(ray.origin, ray.direction, Color.cyan);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit, 10) && Input.GetKeyDown("space"))
                {
                    runWatch = true;
                    _cameraTransform.LookAt(_cameraLookTarget.transform.position);
                }
                
           // }
            else
            {
                _LookAtAvatar();//实现接近collider就抬头的功能
            }


            _FollowAvatar();
               
           

        }

       if (runWatch)
               {
                   if (SlerpTime > 5)
                       up = false;
                   else if (SlerpTime <= 0)
                   {
                       //up = true;
                       runWatch = false;
                   }
                   if(up)
                   SlerpTime += Time.deltaTime;
                   else
                   {
                       SlerpTime -= Time.deltaTime;
                   }
       
                   _Raycast(SlerpTime);
               }
    }
private Vector3 currentPOS;
    private Vector3 targetPOS;
//碰到collider会上下移动的raycast
    private void _Raycast(float currentLerptime)
    {
        // Ray ray = new Ray(_avatarTransform.position ,_avatarLookForward);
        // Debug.DrawRay(ray.origin, ray.direction5, Color.cyan);


        // RaycastHit hit;
        //  if (Physics.Raycast(ray, out hit, 10))
        {
            float distance = 10f;
            float lerptime = 5;
            Debug.Log(_avatarTransform.position);

            currentPOS = _avatarTransform.position;
            currentPOS[0] = (int) currentPOS[0];
            currentPOS[1] = (int) currentPOS[1];
            currentPOS[2] = (int) currentPOS[2];
            targetPOS = _avatarTransform.position + Vector3.up * distance;
            targetPOS[0] = (int) targetPOS[0];
            targetPOS[1] = (int) targetPOS[1];
            targetPOS[2] = (int) targetPOS[2];


            float Perc = currentLerptime / lerptime;
            _cameraLookTarget.transform.position = Vector3.Lerp(currentPOS, targetPOS, Perc);
            if (Perc == 1)
            {
                //runWatch = false;
                SlerpTime = 0;
            }
            
           // Debug.Log(Perc);




        }
        }
    
    //overlap 和 Spherecast 的运用
    private void _Spherecast()
    {
        Collider[] objs;
        objs = Physics.OverlapSphere(_avatarTransform.transform.position + Vector3.up, 1.0f);
        foreach (Collider c in objs)
        {
            _fieldOfView_Applied = Mathf.Lerp(_fieldOfView_Applied, 20, Time.deltaTime);
        }
    }
    
    private void _ManualUpdate()
    {
        _FollowAvatar();
        _ManualControl();
    }
    private void _IdleUpdate()
    {
        
    }
    #endregion

    #region Internal Logic

    float _standingToWalkingSlider = 0;
    float _OOISlider = 0;

    //move camera with mouse move
    private float speedH = 1.0f;
    private float speedV = 1.0f;
    
    
    private float yaw = 0.0f;
    private float pitch = 2.0f;
    private void _ComputeData()
    {
        //where the avatar is facing
        _avatarLookForward = Vector3.Normalize(Vector3.Scale(_avatarTransform.forward, new Vector3(1, 0, 1)));

//        if (_Helper_IsThereOOI())
//        {
//            _OOISlider = Mathf.MoveTowards(_OOISlider, 1, Time.deltaTime);
//            
//            _followDistance_Applied =
//                Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _OOISlider);
//            _verticalOffset_Applied =
//                Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _OOISlider);
//        }
//        else
//        {

//这里silder切换走路和停止的镜头变化

            if (_Helper_IsWalking())
            {
               // Collider[] objs;
              //  objs = Physics.OverlapSphere(_avatarTransform.transform.position + Vector3.up, 2.0f);
               // int i = 0;
               // while(i< objs.Length)
               // {
                    //_cameraTransform.position = _avatarTransform.position - _avatarLookForward * _followDistance_Applied + Vector3.up * _verticalOffset_Applied;
                    //Mathf.MoveTowardsAngle()
                //}
                //if the avatar is walking, the variable approaches to 1
                _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 1, Time.deltaTime);
//实现移动时控制相机！！
                yaw += speedH * Input.GetAxis("Mouse X");
                                pitch -= speedV * Input.GetAxis("Mouse Y");
                                Debug.Log(_cameraTransform.rotation.eulerAngles.x);
                                pitch = Mathf.Clamp(pitch, _avatarTransform.rotation.eulerAngles.x-20, _avatarTransform.rotation.eulerAngles.x+20);
                                yaw = Mathf.Clamp(yaw, _avatarTransform.rotation.eulerAngles.y-25, _avatarTransform.rotation.eulerAngles.y+25);

                                //Quaternion movecam = Quaternion.Euler(pitch, yaw, 0);
                               // _cameraTransform.rotation = Quaternion.Slerp(_cameraTransform.rotation, movecam,
                                 //   Time.deltaTime * smooth);
                                _cameraTransform.eulerAngles = new Vector3(pitch, yaw, 0.0f);
                              //  _cameraTransform.Rotate(Vector3.right *pitch * Time.deltaTime, Space.Self);
                                //_cameraTransform.Rotate(new Vector3(pitch,yaw,0) * Time.deltaTime, Space.Self);
                                



            }
            else
            {
                //if the avatar is standing still, the variable approaches to 0
                _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 0, Time.deltaTime * 3);
                _cameraTransform.LookAt(_cameraLookTarget);
            }

            float _followDistance_Walking = followDistance_Base;
            float _followDistance_Standing = followDistance_Base * 1.5f;

            float _verticalOffset_Walking = verticalOffset_Base;
            float _verticalOffset_Standing = verticalOffset_Base * 2;

            _followDistance_Applied =
                Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _standingToWalkingSlider);
            _verticalOffset_Applied =
                Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _standingToWalkingSlider);

            _fieldOfView_Applied = Mathf.Lerp(fovAtDown, fovAtUp, _standingToWalkingSlider);

    }

    private void _FollowAvatar()
    {
        _camRelativePostion_Auto = _avatarTransform.position;
    
        _cameraLookTarget.position = _avatarTransform.position + avatarObservationOffset_Base;
        
        _cameraTransform.position = _avatarTransform.position - _avatarLookForward * _followDistance_Applied + Vector3.up * _verticalOffset_Applied;
        
        _cameraRotateTarget.position = _avatarTransform.position + avatarObservationOffset_Base;
        //adjusting fov
        Camera.main.fieldOfView = _fieldOfView_Applied;

    }

    private void _LookAtAvatar()
    {
        //_cameraTransform.LookAt(_cameraLookTarget);
        
    }

    private void _LookAtObject(Transform oOI)
    {
        //the look at target moves slowly to where the player is
        Vector3 TargetofLAO;
        Vector3 Center = (oOI.position + _avatarTransform.position)/2;

        //TargetofLAO = Vector3.Lerp(Center, _avatarTransform.position, Time.deltaTime * 30);
        _cameraTransform.LookAt(_avatarLookForward);
        
        
        _OOISlider = Mathf.MoveTowards(_OOISlider, 1, Time.deltaTime);
        print("OOISlider = " + _OOISlider);
            
        _followDistance_Applied =
            Mathf.Lerp((_cameraTransform.position - _avatarTransform.position).z, followDistance_Base, _OOISlider);
        _verticalOffset_Applied =
            Mathf.Lerp((_cameraTransform.position - _avatarTransform.position).y, verticalOffset_Base, _OOISlider);
        
        //but the camera still needs to follow the avatar while doing this？
        _cameraTransform.position = _avatarTransform.position - 3 * _avatarLookForward * _followDistance_Applied + 2 * Vector3.up * _verticalOffset_Applied;
        
        //Camera.main.fieldOfView = _fieldOfView_Applied;

        TimerLookAtOOI -= 1;
    }

    
     public float xSpeed = 120.0f;
         public float ySpeed = 120.0f;
      
         public float yMinLimit = -20f;
         public float yMaxLimit = 50f;

          float x = 0.0f;
          float y = 0.0f;

        //设置相机切入和淡出
          public float minDistance = 2.0f;
          public float maxDistance = 4.0f;
          public float smooth = 10.0f;
          private Vector3 dollyDir;
          
          public float distance;
          
          
    //控制相机旋转的角度在80度以内

    private void _ManualControl()
    {
        // _cameraTransform.LookAt(_cameraRotateTarget);

        

       //右键进入看角色模式 有lerp有raycast有夹角限制
        

        // if (Input.GetAxis("Mouse X") != 0)
        //  _camEulerHold.y += Input.GetAxis("Mouse X");

        //   if (Input.GetAxis("Mouse Y") != 0)
        //  {
        //   float temp = _camEulerHold.x - Input.GetAxis("Mouse Y");
        //保证角度大于零
        // temp = (temp + 360) % 360;

        //   if (temp < 180)
        //       temp = Mathf.Clamp(temp, 0, 80);
        //  else
        //      temp = Mathf.Clamp(temp, 360 - 80, 360);

        //  _camEulerHold.x = temp;
        //  }
        if (_cameraRotateTarget)
        {//float distance = 3.0f;
            x += Input.GetAxis("Mouse X") * xSpeed * distance * 0.02f;
                         y -= Input.GetAxis("Mouse Y") * ySpeed * 0.02f;
              
                         y = ClampAngle(y, yMinLimit, yMaxLimit);
            
            Quaternion rotation = Quaternion.Euler(y, x, 0);


            //Vector3 desireCameraPos =_cameraTransform.TransformPoint(dollyDir * maxDistance);
            
      
            //distance -= hit.distance;

            Vector3 negDistance = new Vector3(0.0f, 0.0f, -distance);
            var position = rotation * negDistance + _cameraRotateTarget.position;

           // Debug.Log("The V3 to be applied is " + _camEulerHold);
            _cameraTransform.rotation = rotation;
            _cameraTransform.position = position;
           
            RaycastHit hit;
            Debug.DrawRay(_cameraRotateTarget.position, _cameraTransform.TransformDirection(Vector3.back), Color.green);
            
            
            if (Physics.Linecast(_cameraRotateTarget.position, _cameraTransform.TransformDirection(Vector3.back), out hit))
            {
                // distance = hit.distance;
                distance = Mathf.Clamp(hit.distance * 0.8f, minDistance, maxDistance);
                // if (distance > 2)
                // {
                //    distance = 2;
                // }
                //  if (distance < 2)
                //  {
                //      distance = 2;
                //  }
              
                
            }
            else
            {
                distance = maxDistance;
            }
            //lerp for smooth the fade in
           // _cameraTransform.transform.position = Vector3.Lerp(_cameraTransform.position, _cameraTransform.TransformDirection(Vector3.back) * distance,
              //  Time.deltaTime * smooth);
        }

    }
    public static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360F)
            angle += 360F;
        if (angle > 360F)
            angle -= 360F;
        return Mathf.Clamp(angle, min, max);
    }

    #endregion

    #region Helper Functions

    private Vector3 _lastPos;
    private Vector3 _currentPos;
    private bool _Helper_IsWalking()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;

        if (velInst > .15f)
            return true;
        else return false;
    }
    private bool _Helper_IsThereOOI()
    {
        //Returns an array with all colliders touching or inside the sphere.
        Collider[] stuffInSphere = Physics.OverlapSphere(_avatarTransform.position, 5f);
        bool _oOIPresent = false;

        for (int i = 0; i < stuffInSphere.Length; i++)
        {
            if (stuffInSphere[i].CompareTag("ObjectOfInterest"))
            {
                _oOIPresent = true;
            }
        }

        return _oOIPresent;
    }

    private Transform _Helper_WhatIsClosestOOI()
    {
        //Sphere Overlap
        //Sort for shortest
        //Return the shortest
        return transform;
    }
    
    #endregion
    
 
    
    
    
}

public enum CameraStates {Manual, Automatic, Idle}
