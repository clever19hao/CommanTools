// MESSAGE HUBSAN_QUAD_STATUS PACKING

#define MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS 58

typedef struct __mavlink_hubsan_quad_status_t
{
 uint8_t target_system; ///< System ID
 uint8_t target_component; ///< Component ID
 uint8_t recording_status; ///< camera status,is recording or not,as defined by MAV_HUBSAN_RECORDING_STATUS enum
 uint8_t quad_mode_status; ///< quadrotor mode status,as defined by MAV_HUBSAN_QUAD_MODE enum
} mavlink_hubsan_quad_status_t;

#define MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN 4
#define MAVLINK_MSG_ID_58_LEN 4

#define MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC 132
#define MAVLINK_MSG_ID_58_CRC 132



#define MAVLINK_MESSAGE_INFO_HUBSAN_QUAD_STATUS { \
	"HUBSAN_QUAD_STATUS", \
	4, \
	{  { "target_system", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_hubsan_quad_status_t, target_system) }, \
         { "target_component", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_hubsan_quad_status_t, target_component) }, \
         { "recording_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 2, offsetof(mavlink_hubsan_quad_status_t, recording_status) }, \
         { "quad_mode_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 3, offsetof(mavlink_hubsan_quad_status_t, quad_mode_status) }, \
         } \
}


/**
 * @brief Pack a hubsan_quad_status message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param recording_status camera status,is recording or not,as defined by MAV_HUBSAN_RECORDING_STATUS enum
 * @param quad_mode_status quadrotor mode status,as defined by MAV_HUBSAN_QUAD_MODE enum
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_quad_status_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t target_system, uint8_t target_component, uint8_t recording_status, uint8_t quad_mode_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, recording_status);
	_mav_put_uint8_t(buf, 3, quad_mode_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#else
	mavlink_hubsan_quad_status_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.recording_status = recording_status;
	packet.quad_mode_status = quad_mode_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
}

/**
 * @brief Pack a hubsan_quad_status message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param target_system System ID
 * @param target_component Component ID
 * @param recording_status camera status,is recording or not,as defined by MAV_HUBSAN_RECORDING_STATUS enum
 * @param quad_mode_status quadrotor mode status,as defined by MAV_HUBSAN_QUAD_MODE enum
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_quad_status_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t target_system,uint8_t target_component,uint8_t recording_status,uint8_t quad_mode_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, recording_status);
	_mav_put_uint8_t(buf, 3, quad_mode_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#else
	mavlink_hubsan_quad_status_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.recording_status = recording_status;
	packet.quad_mode_status = quad_mode_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
}

/**
 * @brief Encode a hubsan_quad_status struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_quad_status C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_quad_status_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hubsan_quad_status_t* hubsan_quad_status)
{
	return mavlink_msg_hubsan_quad_status_pack(system_id, component_id, msg, hubsan_quad_status->target_system, hubsan_quad_status->target_component, hubsan_quad_status->recording_status, hubsan_quad_status->quad_mode_status);
}

/**
 * @brief Encode a hubsan_quad_status struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_quad_status C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_quad_status_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hubsan_quad_status_t* hubsan_quad_status)
{
	return mavlink_msg_hubsan_quad_status_pack_chan(system_id, component_id, chan, msg, hubsan_quad_status->target_system, hubsan_quad_status->target_component, hubsan_quad_status->recording_status, hubsan_quad_status->quad_mode_status);
}

/**
 * @brief Send a hubsan_quad_status message
 * @param chan MAVLink channel to send the message
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param recording_status camera status,is recording or not,as defined by MAV_HUBSAN_RECORDING_STATUS enum
 * @param quad_mode_status quadrotor mode status,as defined by MAV_HUBSAN_QUAD_MODE enum
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hubsan_quad_status_send(mavlink_channel_t chan, uint8_t target_system, uint8_t target_component, uint8_t recording_status, uint8_t quad_mode_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, recording_status);
	_mav_put_uint8_t(buf, 3, quad_mode_status);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
#else
	mavlink_hubsan_quad_status_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.recording_status = recording_status;
	packet.quad_mode_status = quad_mode_status;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
#endif
}

#if MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hubsan_quad_status_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t target_system, uint8_t target_component, uint8_t recording_status, uint8_t quad_mode_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char *buf = (char *)msgbuf;
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, recording_status);
	_mav_put_uint8_t(buf, 3, quad_mode_status);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
#else
	mavlink_hubsan_quad_status_t *packet = (mavlink_hubsan_quad_status_t *)msgbuf;
	packet->target_system = target_system;
	packet->target_component = target_component;
	packet->recording_status = recording_status;
	packet->quad_mode_status = quad_mode_status;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
#endif
}
#endif

#endif

// MESSAGE HUBSAN_QUAD_STATUS UNPACKING


/**
 * @brief Get field target_system from hubsan_quad_status message
 *
 * @return System ID
 */
static inline uint8_t mavlink_msg_hubsan_quad_status_get_target_system(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Get field target_component from hubsan_quad_status message
 *
 * @return Component ID
 */
static inline uint8_t mavlink_msg_hubsan_quad_status_get_target_component(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  1);
}

/**
 * @brief Get field recording_status from hubsan_quad_status message
 *
 * @return camera status,is recording or not,as defined by MAV_HUBSAN_RECORDING_STATUS enum
 */
static inline uint8_t mavlink_msg_hubsan_quad_status_get_recording_status(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  2);
}

/**
 * @brief Get field quad_mode_status from hubsan_quad_status message
 *
 * @return quadrotor mode status,as defined by MAV_HUBSAN_QUAD_MODE enum
 */
static inline uint8_t mavlink_msg_hubsan_quad_status_get_quad_mode_status(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  3);
}

/**
 * @brief Decode a hubsan_quad_status message into a struct
 *
 * @param msg The message to decode
 * @param hubsan_quad_status C-struct to decode the message contents into
 */
static inline void mavlink_msg_hubsan_quad_status_decode(const mavlink_message_t* msg, mavlink_hubsan_quad_status_t* hubsan_quad_status)
{
#if MAVLINK_NEED_BYTE_SWAP
	hubsan_quad_status->target_system = mavlink_msg_hubsan_quad_status_get_target_system(msg);
	hubsan_quad_status->target_component = mavlink_msg_hubsan_quad_status_get_target_component(msg);
	hubsan_quad_status->recording_status = mavlink_msg_hubsan_quad_status_get_recording_status(msg);
	hubsan_quad_status->quad_mode_status = mavlink_msg_hubsan_quad_status_get_quad_mode_status(msg);
#else
	memcpy(hubsan_quad_status, _MAV_PAYLOAD(msg), MAVLINK_MSG_ID_HUBSAN_QUAD_STATUS_LEN);
#endif
}
