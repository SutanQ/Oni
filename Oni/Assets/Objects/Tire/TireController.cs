using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class TireController : Damegeable
{
    public Transform tire;
    [Header("Control")]
    public float tire_diameter = 0.975f;
    public float raycast_forwardDistance = 0.2f;
    public float rotationSpeed = 60.0f;
    public float boostSpeedData = 360.0f;
    public float particleBoostSpeed = 6.0f;
    public float maxRotationAngle = 30.0f;
    public float rotationAngleSpeed = 40.0f;
    public float turnBackAngleSpeed = 20.0f;
    public ParticleSystem tireParticleSystem;
    public ParticleSystem tireParticleSystem2;
    public Volume volume;
    public AudioClip brakesClip;
    [Header("Boost Emiss Material")]
    public EmissMaterial[] emissMaterials;
    public Material dissolveMaterial;
    [Header("Boost")]
    public float BoostMax = 4.0f;
    public float BoostUpSpeed = 4.0f;
    public float BoostDownSpeed = 6.0f;
    public AudioClip BoostClip;
    [Header("Road")]
    public float RoadLength = 10.0f;
    public LayerMask GroundLayer;
    public Transform[] roadsTransforms;
    int roadCurrentIndex = 0;
    int roadMaxIndex;
    [Header("UI")]
    public Text speedUI;
    public Text lengthUI;
    [Header("Target")]
    public LayerMask targetMask;
    public Transform targetCube;
    public LineRenderer lineRenderer;
    public float throwHeight = 0.5f;
    public Transform grenadeThrowPos;
    public GameObject grenadePrefab;
    //public CharacterController characterController;

    //Rigidbody rb;
    Camera cam;
    TireTrack[] tireTracks;
    Coroutine coroutine;
    float boost = 0;
    float psStartSpeed;
    float Boost = 0.0f;
    float lastPos = 0;
    float defaultRotationAngle;
    float currentRotationAngle;

    Vector3 forward;
    Vector3 refCurrentSpeed;
    RaycastHit hitInfo;
    RaycastHit mouseHit;
    bool mouseHitted;
    bool OnGround = false;

    // Start is called before the first frame update
    void Start()
    {
        tireParticleSystem.Stop();
        tireParticleSystem2.Stop();
        psStartSpeed = tireParticleSystem.startSpeed;
        roadMaxIndex = roadsTransforms.Length;
        lastPos = transform.position.x;
        rb = GetComponent<Rigidbody>();
        currentRotationAngle = defaultRotationAngle = transform.eulerAngles.y;
        tireTracks = GetComponentsInChildren<TireTrack>();
        cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        CalForwardGroundAngle(raycast_forwardDistance);
        //CalGroundAngle();
        CalSpeedAndBoost();
        Movement();
        ShootThrow();
        UpdateRoad();
        UpdateUI();

        //transform.GetComponent<Rigidbody>().velocity = new Vector3(GetCurrentSpeed(), 0, 0);
        //Debug.Log("Forward = " + forward);
        //Debug.Log("Speed : = " + (rotationSpeed + boost));
        //Debug.Log("SPEED = " + GetCurrentSpeed() + " KM/HR ");
    }

    private void FixedUpdate()
    {
        MouseLocation();
    }

    /// <summary>
    /// 計算前方距離forwardDistance與地面的角度(用於控制加速度的方向)
    /// </summary>
    void CalForwardGroundAngle(float forwardDistance)
    {
        if (Physics.Raycast(transform.position + transform.forward * forwardDistance, -transform.up, out hitInfo, tire_diameter * 0.5f, GroundLayer))
        {
            forward = Vector3.Cross(transform.right, hitInfo.normal);
            OnGround = true;
            //rb.useGravity = false;
        }
        else
        {
            forward = transform.forward;
            OnGround = false;
            //rb.useGravity = true;
        }
    }

    /// <summary>
    /// 計算目前與地面的角度(用於控制加速度的方向)
    /// </summary>
    void CalGroundAngle()
    {
        if (Physics.Raycast(transform.position, -transform.up, out hitInfo, tire_diameter * 0.5f, GroundLayer))
        {
            forward = Vector3.Cross(transform.right, hitInfo.normal);
            OnGround = true;
            //rb.useGravity = false;
        }
        else
        {
            forward = transform.forward;
            OnGround = false;
            //rb.useGravity = true;
        }
    }

    void ShootThrow()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (mouseHitted)
            {
                //Debug.Log(mouseHit.transform.name + " " + mouseHit.point);
                GameObject g = Instantiate(grenadePrefab, grenadeThrowPos.position, Quaternion.identity);
                g.GetComponent<Grenade>().SetTargetPosAndVelocity(mouseHit.point, GetRbVelocity(), (targetCube.position.y > throwHeight) ? (throwHeight + targetCube.position.y) : throwHeight);
            }
        }
    }

    void MouseLocation()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        mouseHitted = Physics.Raycast(ray, out mouseHit, 30.0f, targetMask);
        if (mouseHitted)
        {
            Vector3 localPos = targetCube.localPosition;
            targetCube.position = mouseHit.point;
            //Debug.Log("hit" + mouseHit.point);
            float height = (targetCube.position.y > throwHeight) ? (throwHeight + targetCube.position.y) : throwHeight;

            float displacementY = targetCube.position.y - grenadeThrowPos.position.y;
            Vector3 displacementXZ = new Vector3(targetCube.position.x - grenadeThrowPos.position.x, 0, targetCube.position.z - grenadeThrowPos.position.z);
            float timeToTarget = Mathf.Sqrt(-2 * height / Physics.gravity.y) + Mathf.Sqrt(2 * (displacementY - height) / Physics.gravity.y);
            Vector3 velocityY = Vector3.up * Mathf.Sqrt(-2 * Physics.gravity.y * height);
            Vector3 velocityXZ = displacementXZ / (Mathf.Sqrt(-2 * height / Physics.gravity.y) + Mathf.Sqrt(2 * (displacementY - height) / Physics.gravity.y));

            Vector3 initVelocity = velocityXZ + velocityY * -Mathf.Sign(Physics.gravity.y);
            lineRenderer.SetPosition(0, grenadeThrowPos.position);
            for (int i = 1; i <= 4; i++)
            {
                float simulationTime = (i / 4.0f) * timeToTarget;
                Vector3 displacement = initVelocity * simulationTime + Physics.gravity * simulationTime * simulationTime / 2f;
                lineRenderer.SetPosition(i, grenadeThrowPos.position + displacement);
            }

            /*
            lineRenderer.SetPosition(0, Vector3.zero);
            lineRenderer.SetPosition(1, new Vector3(targetCube.localPosition.x * 0.25f, height*0.5f, targetCube.localPosition.z * 0.25f));
            lineRenderer.SetPosition(2, new Vector3(targetCube.localPosition.x * 0.5f, height, targetCube.localPosition.z * 0.5f));
            lineRenderer.SetPosition(3, new Vector3(targetCube.localPosition.x * 0.75f, height*0.5f, targetCube.localPosition.z * 0.75f));
            lineRenderer.SetPosition(4, targetCube.localPosition);
            */
            /*
            lineRenderer.SetPosition(0, new Vector3(transform.position.x, 0, transform.position.z));
            lineRenderer.SetPosition(1, new Vector3((targetCube.position.x + transform.position.x) * 0.25f, height * 0.7f, (targetCube.position.z + transform.position.z) * 0.25f));
            lineRenderer.SetPosition(2, new Vector3((targetCube.position.x + transform.position.x) * 0.5f, height, (targetCube.position.z + transform.position.z) * 0.5f));
            lineRenderer.SetPosition(3, new Vector3((targetCube.position.x + transform.position.x) * 0.75f, height * 0.7f, (targetCube.position.z + transform.position.z) * 0.75f));
            lineRenderer.SetPosition(4, targetCube.position);
            */
            
        }
    }



    /// <summary>
    /// 控制Boost與Particle以及計算速度
    /// </summary>
    void CalSpeedAndBoost()
    {
        boost = 0;

        //操作Boost
        if (Input.GetKeyDown(KeyCode.Space))
        {
            //tireParticleSystem.Play();
            AudioManager.instance.PlaySound(BoostClip, transform.position);
        }
        if (Input.GetKey(KeyCode.Space))
        {
            Boost += BoostUpSpeed * Time.deltaTime;
        }
        else
        {
            Boost -= BoostDownSpeed * Time.deltaTime;
        }

        //控制Boost最大最小值
        if (Boost > BoostMax)
            Boost = BoostMax;
        if (Boost < 0.0f)
        {
            Boost = 0.0f;
            if (tireParticleSystem.isPlaying)
                tireParticleSystem.Stop();
        }

        //計算結果
        float lerp = (Boost / BoostMax);
        boost = boostSpeedData * lerp;
        volume.weight = lerp;
        tireParticleSystem.startSpeed = psStartSpeed + particleBoostSpeed * lerp;
        tire.transform.Rotate(Vector3.right, (rotationSpeed + boost) * Time.deltaTime);
        //按下BOOST後會發亮的材質球
        for (int i = 0; i < emissMaterials.Length; i++)
            emissMaterials[i].material.SetFloat("_EmissStrength", emissMaterials[i].maxEmissStrength * lerp);
        dissolveMaterial.SetFloat("_DissolveAmount", Mathf.Lerp(2, 0, lerp));

        if (lerp > 0.2f && OnGround)
        {
            if(!tireParticleSystem.isPlaying)
                tireParticleSystem.Play();
        }
        else
        {
            if (tireParticleSystem.isPlaying)
                tireParticleSystem.Stop();
        }
        //第二Particle
        if (lerp > 0.8f && OnGround)
        {
            if (!tireParticleSystem2.isPlaying)
            {
                tireParticleSystem2.Play();
                SetTireTrack(true);
            }
        }
        else
        {
            if (tireParticleSystem2.isPlaying)
            {
                tireParticleSystem2.Stop();
                SetTireTrack(false);
            }
        }
    }


    /// <summary>
    /// 移動輪胎
    /// </summary>
    void Movement()
    {
        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        //Vector3 move = new Vector3(h, 0, v) * (rotationSpeed + boost) * Time.deltaTime;

        ////轉彎
        if (currentRotationAngle > defaultRotationAngle)
            currentRotationAngle -= turnBackAngleSpeed * Time.deltaTime;
        if (currentRotationAngle < defaultRotationAngle)
            currentRotationAngle += turnBackAngleSpeed * Time.deltaTime;

        currentRotationAngle -= v * rotationAngleSpeed * Time.deltaTime;
        currentRotationAngle = Mathf.Clamp(currentRotationAngle, defaultRotationAngle - maxRotationAngle, defaultRotationAngle + maxRotationAngle);
        if (Mathf.Abs(currentRotationAngle - 90.0f) < 0.2f)
            currentRotationAngle = 90.0f;
        transform.eulerAngles = new Vector3(transform.eulerAngles.x, currentRotationAngle, -(currentRotationAngle - 90.0f));
        ////轉彎
        //transform.position = Vector3.Lerp(transform.position, transform.position + move, Time.deltaTime);

        //if (Mathf.Abs(forward.y) < 0.1f)
        //    forward = new Vector3(forward.x, 0, forward.z);

        
        if (OnGround)
            rb.velocity = Vector3.Lerp(rb.velocity, forward.normalized * GetCurrentSpeed(), Time.deltaTime);
            //rb.velocity = Vector3.SmoothDamp(rb.velocity, forward.normalized * GetCurrentSpeed(), ref refCurrentSpeed, 0.2f);

        //if (Input.GetKeyDown(KeyCode.C))
        //    rb.AddForce(Vector3.up * 300);

    }

    /// <summary>
    /// 重覆移動背景
    /// </summary>
    void UpdateRoad()
    {
        //場景往前版
        if(transform.position.x >= lastPos + RoadLength)
        {
            lastPos = lastPos + RoadLength;
            roadsTransforms[roadCurrentIndex].position += RoadLength * roadMaxIndex * Vector3.right;//new Vector3(roadsTransforms[roadCurrentIndex].position.x + RoadLength * roadMaxIndex, roadsTransforms[roadCurrentIndex].position.y, roadsTransforms[roadCurrentIndex].position.z);
            roadCurrentIndex++;
            if (roadCurrentIndex >= roadMaxIndex)
                roadCurrentIndex = 0;
        }


        /* 場景後退版
        for (int i = 0; i < roadMaxIndex; i++)
            roadsTransforms[i].Translate(new Vector3(-GetCurrentSpeed() * fixedDeltaTime, 0, 0), Space.Self);

        if(roadsTransforms[roadCurrentIndex].position.x < -RoadLength * 2)
        {
            roadsTransforms[roadCurrentIndex].position = new Vector3(roadsTransforms[roadCurrentIndex].position.x + RoadLength * roadMaxIndex, roadsTransforms[roadCurrentIndex].position.y, roadsTransforms[roadCurrentIndex].position.z);
            roadCurrentIndex++;
            if (roadCurrentIndex >= roadMaxIndex)
                roadCurrentIndex = 0;
        }
        */
    }

    /// <summary>
    /// 更新UI (目前時速跟行走距離)
    /// </summary>
    void UpdateUI()
    {
        speedUI.text = GetCurrentSpeed().ToString("F0");
        lengthUI.text = transform.position.x.ToString("F0");
    }

    /// <summary>
    /// 獲得現在時速(Km/hr)
    /// </summary>
    /// <returns></returns>
    public float GetCurrentSpeed()
    {
        //       每秒轉圈次數(每秒角度/360度)   * 輪胎直徑(公尺) * 拍    * 3600(走一小時) / 1000(轉成公里)
        return (((rotationSpeed + boost) / 360) * tire_diameter * Mathf.PI) * 3600 / 1000;
    }

    public Vector3 GetRbVelocity()
    {
        return rb.velocity;
    }

    void SetTireTrack(bool b)
    {
        for(int i = 0; i < tireTracks.Length; i++)
        {
            tireTracks[i].SetTracking(b);
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position - Vector3.up * tire_diameter * 0.5f);
    }

    [System.Serializable]
    public class EmissMaterial
    {
        public float maxEmissStrength;
        public Material material;
    }
}
