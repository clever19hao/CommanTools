// MESSAGE HUBSAN_QUAD_MODE PACKING

#define MAVLINK_MSG_ID_HUBSAN_QUAD_MODE 53

typedef struct __mavlink_hubsan_quad_mode_t
{
 uint8_t target_system; ///< System ID
 uint8_t target_component; ///< Component ID
 uint8_t hubsan_quad_mode; ///< hubsan quad mode,as defined by MAV_HUBSAN_QUAD_MODE enum
} mavlink_hubsan_quad_mode_t;

#define MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN 3
#define MAVLINK_MSG_ID_53_LEN 3

#define MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC 221
#define MAVLINK_MSG_ID_53_CRC 221



#define MAVLINK_MESSAGE_INFO_HUBSAN_QUAD_MODE { \
	"HUBSAN_QUAD_MODE", \
	3, \
	{  { "target_system", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_hubsan_quad_mode_t, target_system) }, \
         { "target_component", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_hubsan_quad_mode_t, target_component) }, \
         { "hubsan_quad_mode", NULL, MAVLINK_TYPE_UINT8_T, 0, 2, offsetof(mavlink_hubsan_quad_mode_t, hubsan_quad_mode) }, \
         } \
}


/**
 * @brief Pack a hubsan_quad_mode message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param hubsan_quad_mode hubsan quad mode,as defined by MAV_HUBSAN_QUAD_MODE enum
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_quad_mode_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t target_system, uint8_t target_component, uint8_t hubsan_quad_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, hubsan_quad_mode);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#else
	mavlink_hubsan_quad_mode_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.hubsan_quad_mode = hubsan_quad_mode;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_QUAD_MODE;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
}

/**
 * @brief Pack a hubsan_quad_mode message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param target_system System ID
 * @param target_component Component ID
 * @param hubsan_quad_mode hubsan quad mode,as defined by MAV_HUBSAN_QUAD_MODE enum
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_quad_mode_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t target_system,uint8_t target_component,uint8_t hubsan_quad_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, hubsan_quad_mode);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#else
	mavlink_hubsan_quad_mode_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.hubsan_quad_mode = hubsan_quad_mode;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_QUAD_MODE;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
}

/**
 * @brief Encode a hubsan_quad_mode struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_quad_mode C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_quad_mode_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hubsan_quad_mode_t* hubsan_quad_mode)
{
	return mavlink_msg_hubsan_quad_mode_pack(system_id, component_id, msg, hubsan_quad_mode->target_system, hubsan_quad_mode->target_component, hubsan_quad_mode->hubsan_quad_mode);
}

/**
 * @brief Encode a hubsan_quad_mode struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_quad_mode C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_quad_mode_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hubsan_quad_mode_t* hubsan_quad_mode)
{
	return mavlink_msg_hubsan_quad_mode_pack_chan(system_id, component_id, chan, msg, hubsan_quad_mode->target_system, hubsan_quad_mode->target_component, hubsan_quad_mode->hubsan_quad_mode);
}

/**
 * @brief Send a hubsan_quad_mode message
 * @param chan MAVLink channel to send the message
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param hubsan_quad_mode hubsan quad mode,as defined by MAV_HUBSAN_QUAD_MODE enum
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hubsan_quad_mode_send(mavlink_channel_t chan, uint8_t target_system, uint8_t target_component, uint8_t hubsan_quad_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, hubsan_quad_mode);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
#else
	mavlink_hubsan_quad_mode_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.hubsan_quad_mode = hubsan_quad_mode;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
#endif
}

#if MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hubsan_quad_mode_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t target_system, uint8_t target_component, uint8_t hubsan_quad_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char *buf = (char *)msgbuf;
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, hubsan_quad_mode);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, buf, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
#else
	mavlink_hubsan_quad_mode_t *packet = (mavlink_hubsan_quad_mode_t *)msgbuf;
	packet->target_system = target_system;
	packet->target_component = target_component;
	packet->hubsan_quad_mode = hubsan_quad_mode;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
#endif
}
#endif

#endif

// MESSAGE HUBSAN_QUAD_MODE UNPACKING


/**
 * @brief Get field target_system from hubsan_quad_mode message
 *
 * @return System ID
 */
static inline uint8_t mavlink_msg_hubsan_quad_mode_get_target_system(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Get field target_component from hubsan_quad_mode message
 *
 * @return Component ID
 */
static inline uint8_t mavlink_msg_hubsan_quad_mode_get_target_component(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  1);
}

/**
 * @brief Get field hubsan_quad_mode from hubsan_quad_mode message
 *
 * @return hubsan quad mode,as defined by MAV_HUBSAN_QUAD_MODE enum
 */
static inline uint8_t mavlink_msg_hubsan_quad_mode_get_hubsan_quad_mode(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  2);
}

/**
 * @brief Decode a hubsan_quad_mode message into a struct
 *
 * @param msg The message to decode
 * @param hubsan_quad_mode C-struct to decode the message contents into
 */
static inline void mavlink_msg_hubsan_quad_mode_decode(const mavlink_message_t* msg, mavlink_hubsan_quad_mode_t* hubsan_quad_mode)
{
#if MAVLINK_NEED_BYTE_SWAP
	hubsan_quad_mode->target_system = mavlink_msg_hubsan_quad_mode_get_target_system(msg);
	hubsan_quad_mode->target_component = mavlink_msg_hubsan_quad_mode_get_target_component(msg);
	hubsan_quad_mode->hubsan_quad_mode = mavlink_msg_hubsan_quad_mode_get_hubsan_quad_mode(msg);
#else
	memcpy(hubsan_quad_mode, _MAV_PAYLOAD(msg), MAVLINK_MSG_ID_HUBSAN_QUAD_MODE_LEN);
#endif
}
