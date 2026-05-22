var socketEvents = {
    test: [
        function (data) {
            alert('Test event received: ');
        },
    ],
}

var socket;
var messageQueue = [];

function initWebSocket(send = null) {
    if (socket && socket.readyState === WebSocket.OPEN) {
        if (send) {
            socket.send(JSON.stringify(send));
        }
        return socket;
    }
    
    // اگر سوکت در حال اتصال است، پیام را به صف اضافه کن
    if (socket && socket.readyState === WebSocket.CONNECTING) {
        if (send) {
            messageQueue.push(send);
        }
        return socket;
    }
    
    socket = new WebSocket("/ws");
    socket.onmessage = (e) => {
        var data = JSON.parse(e.data);
        console.log(data);
        if (socketEvents[data.path]) {
            socketEvents[data.path].forEach((callback) => {
                callback(data);
            });
        }
    };

    socket.onopen = (e)  => {
        console.log('Web Socket opened');
        
        // ارسال پیام اولیه (اگر وجود داشته باشد)
        if (send) {
            socket.send(JSON.stringify(send));
        }
        
        // ارسال تمام پیام‌های صف
        while (messageQueue.length > 0) {
            var queuedMessage = messageQueue.shift();
            socket.send(JSON.stringify(queuedMessage));
        }
    }

    socket.onerror = (e) => {
        console.error('Web Socket error');
    }

    socket.onclose = (e) => {
        if (socketEvents.close) {
            socketEvents.close.forEach((callback) => {
                callback(e);
            });
        }
        /// Try to reconnect after 3 seconds
        setTimeout(() => {
            console.log('Reconnecting Web Socket...');
            initWebSocket();
        }, 3000);
    };

    return socket;
}

function addSocketEvent(key, event) {
    if (!socketEvents[key]) {
        socketEvents[key] = [];
    }
    socketEvents[key].push(event);
}

function finchSocket(path, data, onReceive = null) {
    initWebSocket({
        'path': path,
        'data': data
    });
    if (onReceive) {
        addSocketEvent(path, onReceive);
    }
}

export { initWebSocket, addSocketEvent, finchSocket };