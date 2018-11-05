// MESSAGE HUBSAN_ACK PACKING

#define MAVLINK_MSG_ID_HUBSAN_ACK 52

typedef struct __mavlink_hubsan_ack_t
{
 uint8_t target_system; ///< System ID
 uint8_t target_component; ///< Component ID
 uint8_t msgid; ///< ID of message in payload
 uint8_t param1; ///< Parameter 1, as defined by MAV_CMD/MAV_RESULT enum.
 uint8_t param2; ///< Parameter 2, as defined by MAV_CMD/MAV_RESULT enum.
 uint8_t param3; ///< Parameter 3, as defined by MAV_CMD/MAV_RESULT enum.
 uint8_t param4; ///< Parameter 4, as defined by MAV_CMD/MAV_RESULT enum.
} mavlink_hubsan_ack_t;

#define MAVLINK_MSG_ID_HUBSAN_ACK_LEN 7
#define MAVLINK_MSG_ID_52_LEN 7

#define MAVLINK_MSG_ID_HUBSAN_ACK_CRC 221
#define MAVLINK_MSG_ID_52_CRC 221



#define MAVLINK_MESSAGE_INFO_HUBSAN_ACK { \
	"HUBSAN_ACK", \
	7, \
	{  { "target_system", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_hubsan_ack_t, target_system) }, \
         { "target_component", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_hubsan_ack_t, target_component) }, \
         { "msgid", NULL, MAVLINK_TYPE_UINT8_T, 0, 2, offsetof(mavlink_hubsan_ack_t, msgid) }, \
         { "param1", NULL, MAVLINK_TYPE_UINT8_T, 0, 3, offsetof(mavlink_hubsan_ack_t, param1) }, \
         { "param2", NULL, MAVLINK_TYPE_UINT8_T, 0, 4, offsetof(mavlink_hubsan_ack_t, param2) }, \
         { "param3", NULL, MAVLINK_TYPE_UINT8_T, 0, 5, offsetof(mavlink_hubsan_ack_t, param3) }, \
         { "param4", NULL, MAVLINK_TYPE_UINT8_T, 0, 6, offsetof(mavlink_hubsan_ack_t, param4) }, \
         } \
}


/**
 * @brief Pack a hubsan_ack message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param msgid ID of message in payload
 * @param param1 Parameter 1, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param2 Parameter 2, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param3 Parameter 3, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param4 Parameter 4, as defined by MAV_CMD/MAV_RESULT enum.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_ack_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t target_system, uint8_t target_component, uint8_t msgid, uint8_t param1, uint8_t param2, uint8_t param3, uint8_t param4)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_ACK_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, msgid);
	_mav_put_uint8_t(buf, 3, param1);
	_mav_put_uint8_t(buf, 4, param2);
	_mav_put_uint8_t(buf, 5, param3);
	_mav_put_uint8_t(buf, 6, param4);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#else
	mavlink_hubsan_ack_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.msgid = msgid;
	packet.param1 = param1;
	packet.param2 = param2;
	packet.param3 = param3;
	packet.param4 = param4;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_ACK;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
}

/**
 * @brief Pack a hubsan_ack message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param target_system System ID
 * @param target_component Component ID
 * @param msgid ID of message in payload
 * @param param1 Parameter 1, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param2 Parameter 2, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param3 Parameter 3, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param4 Parameter 4, as defined by MAV_CMD/MAV_RESULT enum.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_ack_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t target_system,uint8_t target_component,uint8_t msgid,uint8_t param1,uint8_t param2,uint8_t param3,uint8_t param4)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_ACK_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, msgid);
	_mav_put_uint8_t(buf, 3, param1);
	_mav_put_uint8_t(buf, 4, param2);
	_mav_put_uint8_t(buf, 5, param3);
	_mav_put_uint8_t(buf, 6, param4);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#else
	mavlink_hubsan_ack_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.msgid = msgid;
	packet.param1 = param1;
	packet.param2 = param2;
	packet.param3 = param3;
	packet.param4 = param4;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_ACK;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
}

/**
 * @brief Encode a hubsan_ack struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_ack C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_ack_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hubsan_ack_t* hubsan_ack)
{
	return mavlink_msg_hubsan_ack_pack(system_id, component_id, msg, hubsan_ack->target_system, hubsan_ack->target_component, hubsan_ack->msgid, hubsan_ack->param1, hubsan_ack->param2, hubsan_ack->param3, hubsan_ack->param4);
}

/**
 * @brief Encode a hubsan_ack struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_ack C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_ack_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hubsan_ack_t* hubsan_ack)
{
	return mavlink_msg_hubsan_ack_pack_chan(system_id, component_id, chan, msg, hubsan_ack->target_system, hubsan_ack->target_component, hubsan_ack->msgid, hubsan_ack->param1, hubsan_ack->param2, hubsan_ack->param3, hubsan_ack->param4);
}

/**
 * @brief Send a hubsan_ack message
 * @param chan MAVLink channel to send the message
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param msgid ID of message in payload
 * @param param1 Parameter 1, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param2 Parameter 2, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param3 Parameter 3, as defined by MAV_CMD/MAV_RESULT enum.
 * @param param4 Parameter 4, as defined by MAV_CMD/MAV_RESULT enum.
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hubsan_ack_send(mavlink_channel_t chan, uint8_t target_system, uint8_t target_component, uint8_t msgid, uint8_t param1, uint8_t param2, uint8_t param3, uint8_t param4)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_ACK_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, msgid);
	_mav_put_uint8_t(buf, 3, param1);
	_mav_put_uint8_t(buf, 4, param2);
	_mav_put_uint8_t(buf, 5, param3);
	_mav_put_uint8_t(buf, 6, param4);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
#else
	mavlink_hubsan_ack_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.msgid = msgid;
	packet.param1 = param1;
	packet.param2 = param2;
	packet.param3 = param3;
	packet.param4 = param4;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
#endif
}

#if MAVLINK_MSG_ID_HUBSAN_ACK_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hubsan_ack_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t target_system, uint8_t target_component, uint8_t msgid, uint8_t param1, uint8_t param2, uint8_t param3, uint8_t param4)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char *buf = (char *)msgbuf;
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_uint8_t(buf, 2, msgid);
	_mav_put_uint8_t(buf, 3, param1);
	_mav_put_uint8_t(buf, 4, param2);
	_mav_put_uint8_t(buf, 5, param3);
	_mav_put_uint8_t(buf, 6, param4);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, buf, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
#else
	mavlink_hubsan_ack_t *packet = (mavlink_hubsan_ack_t *)msgbuf;
	packet->target_system = target_system;
	packet->target_component = target_component;
	packet->msgid = msgid;
	packet->param1 = param1;
	packet->param2 = param2;
	packet->param3 = param3;
	packet->param4 = param4;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN, MAVLINK_MSG_ID_HUBSAN_ACK_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_ACK, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
#endif
}
#endif

#endif

// MESSAGE HUBSAN_ACK UNPACKING


/**
 * @brief Get field target_system from hubsan_ack message
 *
 * @return System ID
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_target_system(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Get field target_component from hubsan_ack message
 *
 * @return Component ID
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_target_component(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  1);
}

/**
 * @brief Get field msgid from hubsan_ack message
 *
 * @return ID of message in payload
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_msgid(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  2);
}

/**
 * @brief Get field param1 from hubsan_ack message
 *
 * @return Parameter 1, as defined by MAV_CMD/MAV_RESULT enum.
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_param1(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  3);
}

/**
 * @brief Get field param2 from hubsan_ack message
 *
 * @return Parameter 2, as defined by MAV_CMD/MAV_RESULT enum.
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_param2(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  4);
}

/**
 * @brief Get field param3 from hubsan_ack message
 *
 * @return Parameter 3, as defined by MAV_CMD/MAV_RESULT enum.
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_param3(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  5);
}

/**
 * @brief Get field param4 from hubsan_ack message
 *
 * @return Parameter 4, as defined by MAV_CMD/MAV_RESULT enum.
 */
static inline uint8_t mavlink_msg_hubsan_ack_get_param4(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  6);
}

/**
 * @brief Decode a hubsan_ack message into a struct
 *
 * @param msg The message to decode
 * @param hubsan_ack C-struct to decode the message contents into
 */
static inline void mavlink_msg_hubsan_ack_decode(const mavlink_message_t* msg, mavlink_hubsan_ack_t* hubsan_ack)
{
#if MAVLINK_NEED_BYTE_SWAP
	hubsan_ack->target_system = mavlink_msg_hubsan_ack_get_target_system(msg);
	hubsan_ack->target_component = mavlink_msg_hubsan_ack_get_target_component(msg);
	hubsan_ack->msgid = mavlink_msg_hubsan_ack_get_msgid(msg);
	hubsan_ack->param1 = mavlink_msg_hubsan_ack_get_param1(msg);
	hubsan_ack->param2 = mavlink_msg_hubsan_ack_get_param2(msg);
	hubsan_ack->param3 = mavlink_msg_hubsan_ack_get_param3(msg);
	hubsan_ack->param4 = mavlink_msg_hubsan_ack_get_param4(msg);
#else
	memcpy(hubsan_ack, _MAV_PAYLOAD(msg), MAVLINK_MSG_ID_HUBSAN_ACK_LEN);
#endif
}
