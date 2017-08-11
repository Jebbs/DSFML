/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 */

///A module containing the Ftp class.
module dsfml.network.ftp;

import core.time;

import dsfml.network.ipaddress;


/**
 * An FTP client.
 *
 * The Ftp class is a very simple FTP client that allows you to communicate with
 * an FTP server.
 *
 * The FTP protocol allows you to manipulate a remote file system (list files,
 * upload, download, create, remove, ...).
 */
class Ftp
{
    /// Enumeration of transfer modes.
    enum TransferMode
    {
        /// Binary mode (file is transfered as a sequence of bytes)
        Binary,
        /// Text mode using ASCII encoding.
        Ascii,
        /// Text mode using EBCDIC encoding.
        Ebcdic,
    }

    package sfFtp* sfPtr;

    /// Default Constructor.
    this()
    {
        sfPtr = sfFtp_create();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfFtp_destroy(sfPtr);
    }


    /**
     * Get the current working directory.
     *
     * The working directory is the root path for subsequent operations
     * involving directories and/or filenames.
     *
     * Returns: Server response to the request.
     */
    DirectoryResponse getWorkingDirectory()
    {
        return new DirectoryResponse(sfFtp_getWorkingDirectory(sfPtr));
    }

    /**
     * Get the contents of the given directory.
     *
     * This function retrieves the sub-directories and files contained in the
     * given directory. It is not recursive. The directory parameter is relative
     * to the current working directory.
     *
     * Returns: Server response to the request.
     */
    ListingResponse getDirectoryListing(const(char)[] directory = "")
    {
        import dsfml.system.string;
        return new ListingResponse(sfFtp_getDirectoryListing(sfPtr, directory.ptr, directory.length));
    }

    /**
     * Change the current working directory.
     *
     * The new directory must be relative to the current one.
     *
     * Returns: Server response to the request.
     */
    Response changeDirectory(const(char)[] directory)
    {
        import dsfml.system.string;
        return new Response(sfFtp_changeDirectory(sfPtr, directory.ptr,
                                                  directory.length));
    }

    /**
     * Connect to the specified FTP server.
     *
     * The port has a default value of 21, which is the standard port used by
     * the FTP protocol. You shouldn't use a different value, unless you really
     * know what you do.
     *
     * This function tries to connect to the server so it may take a while to
     * complete, especially if the server is not reachable. To avoid blocking
     * your application for too long, you can use a timeout. The default value,
     * Duration.Zero, means that the system timeout will be used (which is
     * usually pretty long).
     *
     * Params:
     * 		address = Address of the FTP server to connect to
     * 		port    = Port used for the connection
     * 		timeout = Maximum time to wait
     *
     * Returns: Server response to the request.
     */
    Response connect(IpAddress address, ushort port = 21, Duration timeout = Duration.zero())
    {
        return new Response(sfFtp_connect(sfPtr, &address, port, timeout.total!"usecs"));
    }

    /**
     * Connect to the specified FTP server.
     *
     * The port has a default value of 21, which is the standard port used by
     * the FTP protocol. You shouldn't use a different value, unless you really
     * know what you do.
     *
     * This function tries to connect to the server so it may take a while to
     * complete, especially if the server is not reachable. To avoid blocking
     * your application for too long, you can use a timeout. The default value,
     * Duration.Zero, means that the system timeout will be used (which is
     * usually pretty long).
     *
     * Params:
     * 		address = Name or ddress of the FTP server to connect to
     * 		port    = Port used for the connection
     * 		timeout = Maximum time to wait
     *
     * Returns: Server response to the request.
     */
    Response connect(const(char)[] address, ushort port = 21, Duration timeout = Duration.zero())
    {
        auto iaddress = IpAddress(address);
        return new Response(sfFtp_connect(sfPtr, &iaddress, port, timeout.total!"usecs"));
    }

    /**
     * Remove an existing directory.
     *
     * The directory to remove must be relative to the current working
     * directory. Use this function with caution, the directory will be removed
     * permanently!
     *
     * Params:
     * 		name = Name of the directory to remove
     *
     * Returns: Server response to the request.
     */
    Response deleteDirectory(const(char)[] name)
    {
        import dsfml.system.string;
        return new Response(sfFtp_deleteDirectory(sfPtr, name.ptr, name.length));
    }

    /**
     * Remove an existing file.
     *
     * The file name must be relative to the current working directory. Use this
     * function with caution, the file will be removed permanently!
     *
     * Params:
     *      name = Name of the file to remove
     *
     * Returns: Server response to the request.
     */
    Response deleteFile(const(char)[] name)
    {
        import dsfml.system.string;
        return new Response(sfFtp_deleteFile(sfPtr, name.ptr, name.length));
    }

    /**
     * Close the connection with the server.
     *
     * Returns: Server response to the request.
     */
    Response disconnect()
    {
        import dsfml.system.string;
        return new Response(sfFtp_disconnect(sfPtr));
    }

    /**
     * Download a file from the server.
     *
     * The filename of the distant file is relative to the current working
     * directory of the server, and the local destination path is relative to
     * the current directory of your application.
     *
     * Params:
     * 		remoteFile = Filename of the distant file to download
     * 		localPath  = Where to put to file on the local computer
     * 		mode = Transfer mode
     *
     * Returns: Server response to the request.
     */
    Response download(const(char)[] remoteFile, const(char)[] localPath, TransferMode mode = TransferMode.Binary)
    {
        import dsfml.system.string;
        return new Response(sfFtp_download(sfPtr, remoteFile.ptr, remoteFile.length, localPath.ptr, localPath.length ,mode));
    }

    /**
     * Send a null command to keep the connection alive.
     *
     * This command is useful because the server may close the connection
     * automatically if no command is sent.
     *
     * Returns: Server response to the request.
     */
    Response keepAlive()
    {
        return new Response(sfFtp_keepAlive(sfPtr));
    }

    /**
     * Log in using an anonymous account.
     *
     * Logging in is mandatory after connecting to the server. Users that are
     * not logged in cannot perform any operation.
     *
     * Returns: Server response to the request.
     */
    Response login()
    {
        return new Response(sfFtp_loginAnonymous(sfPtr));
    }

    /**
     * Log in using a username and a password.
     *
     * Logging in is mandatory after connecting to the server. Users that are
     * not logged in cannot perform any operation.
     *
     * Params:
     * 		name = User name
     * 		password = The password
     *
     * Returns: Server response to the request.
     */
    Response login(const(char)[] name, const(char)[] password)
    {
        import dsfml.system.string;
        return new Response(sfFtp_login(sfPtr, name.ptr, name.length, password.ptr, password.length));
    }

    /**
     * Go to the parent directory of the current one.
     *
     * Returns: Server response to the request.
     */
    Response parentDirectory()
    {
        import dsfml.system.string;
        return new Response(sfFtp_parentDirectory(sfPtr));
    }

    /**
     * Create a new directory.
     *
     * The new directory is created as a child of the current working directory.
     *
     * Params:
     * 		name = Name of the directory to create
     *
     * Returns: Server response to the request.
     */
    Response createDirectory(const(char)[] name)
    {
        import dsfml.system.string;
        return new Response(sfFtp_createDirectory(sfPtr, name.ptr, name.length));
    }

    /**
     * Rename an existing file.
     *
     * The filenames must be relative to the current working directory.
     *
     * Params:
     * 		file = File to rename
     * 		newName = New name of the file
     *
     * Returns: Server response to the request.
     */
    Response renameFile(const(char)[] file, const(char)[] newName)
    {
        import dsfml.system.string;
        return new Response(sfFtp_renameFile(sfPtr, file.ptr, file.length, newName.ptr, newName.length));
    }

    /**
     * Upload a file to the server.
     *
     * The name of the local file is relative to the current working directory
     * of your application, and the remote path is relative to the current
     * directory of the FTP server.
     *
     * Params:
     * 		localFile = Path of the local file to upload
     * 		remotePath = Where to put the file on the server
     * 		mode = Transfer mode
     *
     * Returns: Server response to the request.
     */
    Response upload(const(char)[] localFile, const(char)[] remotePath, TransferMode mode = TransferMode.Binary)
    {
        import dsfml.system.string;
        return new Response(sfFtp_upload(sfPtr, localFile.ptr, localFile.length, remotePath.ptr, remotePath.length, mode));
    }

    /**
     * Send a command to the FTP server.
     *
     * While the most often used commands are provided as member functions in
     * the Ftp class, this method can be used to send any FTP command to the
     * server. If the command requires one or more parameters, they can be
     * specified in parameter. If the server returns information, you can
     * extract it from the response using getMessage().
     *
     * Params:
     * 		command = Command to send
     * 		parameter = Command parameter
     *
     * Returns: Server response to the request.
     */
    Response sendCommand(const(char)[] command, const(char)[] parameter) {
        import dsfml.system.string;
        return new Response(sfFtp_sendCommand(sfPtr, command.ptr, command.length, parameter.ptr, parameter.length));
    }

    /// Specialization of FTP response returning a directory.
    class DirectoryResponse:Response
    {
        private string Directory;

        //Internally used constructor
        package this(sfFtpDirectoryResponse* FtpDirectoryResponce)
        {
            import dsfml.system.string;

            Directory = dsfml.system.string.toString(sfFtpDirectoryResponse_getDirectory(FtpDirectoryResponce));

            super(sfFtpDirectoryResponse_getStatus(FtpDirectoryResponce), sfFtpDirectoryResponse_getMessage(FtpDirectoryResponce));

            sfFtpDirectoryResponse_destroy(FtpDirectoryResponce);
        }

        /**
         * Get the directory returned in the response.
         *
         * Returns: Directory name.
         */
        string getDirectory()
        {
            return Directory;
        }
    }

    /// Specialization of FTP response returning a filename lisiting.
    class ListingResponse:Response
    {
        private string[] Filenames;

        //Internally used constructor
        package this(sfFtpListingResponse* FtpListingResponce)
        {
            import dsfml.system.string;

            Filenames.length = sfFtpListingResponse_getCount(FtpListingResponce);
            for(int i = 0; i < Filenames.length; i++)
            {
                Filenames[i] = dsfml.system.string.toString(sfFtpListingResponse_getName(FtpListingResponce,i));
            }

            super(sfFtpListingResponse_getStatus(FtpListingResponce), sfFtpListingResponse_getMessage(FtpListingResponce));

            sfFtpListingResponse_destroy(FtpListingResponce);

        }

        /**
         * Return the array of directory/file names.
         *
         * Returns: Array containing the requested listing.
         */
        const(string[]) getFilenames()
        {
            return Filenames;
        }
    }

    ///Define a FTP response.
    class Response
    {
        /// Status codes possibly returned by a FTP response.
        enum Status
        {
            RestartMarkerReply = 110,
            ServiceReadySoon = 120,
            DataConnectionAlreadyOpened = 125,
            OpeningDataConnection = 150,

            Ok = 200,
            PointlessCommand = 202,
            SystemStatus = 211,
            DirectoryStatus = 212,
            FileStatus = 213,
            HelpMessage = 214,
            SystemType = 215,
            ServiceReady = 220,
            ClosingConnection = 221,
            DataConnectionOpened = 225,
            ClosingDataConnection = 226,
            EnteringPassiveMode = 227,
            LoggedIn = 230,
            FileActionOk = 250,
            DirectoryOk = 257,

            NeedPassword = 331,
            NeedAccountToLogIn = 332,
            NeedInformation = 350,
            ServiceUnavailable = 421,
            DataConnectionUnavailable = 425,
            TransferAborted = 426,
            FileActionAborted = 450,
            LocalError = 451,
            InsufficientStorageSpace = 452,

            CommandUnknown = 500,
            ParametersUnknown = 501,
            CommandNotImplemented = 502,
            BadCommandSequence = 503,
            ParameterNotImplemented = 504,
            NotLoggedIn = 530,
            NeedAccountToStore = 532,
            FileUnavailable = 550,
            PageTypeUnknown = 551,
            NotEnoughMemory = 552,
            FilenameNotAllowed = 553,

            InvalidResponse = 1000,
            ConnectionFailed = 1001,
            ConnectionClosed = 1002,
            InvalidFile = 1003,
        }

        private Status FtpStatus;
        private string Message;

        //Internally used constructor.
        package this(sfFtpResponse* FtpResponce)
        {
            this(sfFtpResponse_getStatus(FtpResponce),sfFtpResponse_getMessage(FtpResponce));
            sfFtpResponse_destroy(FtpResponce);
        }

        //Internally used constructor.
        package this(Ftp.Response.Status status = Ftp.Response.Status.InvalidResponse, const(char)* message = "")
        {
            import dsfml.system.string;
            FtpStatus = status;
            Message = dsfml.system.string.toString(message);
        }

        /**
         * Get the full message contained in the response.
         *
         * Returns: The message.
         */
        string getMessage() const
        {
            return Message;
        }

        /**
         * Get the status code of the response.
         *
         * Returns: Status code.
         */
        Status getStatus() const
        {
            return FtpStatus;
        }

        /**
         * Check if the status code means a success.
         *
         * This function is defined for convenience, it is equivalent to testing
         * if the status code is < 400.
         *
         * Returns: True if the status is a success, false if it is a failure.
         */
        bool isOk() const
        {
            return FtpStatus< 400;
        }
    }
}
unittest
{
    version(DSFML_Unittest_Network)
    {
        import std.stdio;
        import dsfml.system.err;

        writeln("Unittest for Ftp");

        auto ftp = new Ftp();

        auto responce = ftp.connect("ftp.hq.nasa.gov");//Thanks, NASA!

        if(responce.isOk())
        {
            writeln("Connected! Huzzah!");
        }
        else
        {
            writeln("Uh-oh");
            writeln(responce.getStatus());
            assert(0);
        }

        //annonymous log in
        responce = ftp.login();
        if(responce.isOk())
        {
            writeln("Logged in! Huzzah!");
        }
        else
        {
            writeln("Uh-oh");
            writeln(responce.getStatus());
            assert(0);
        }


        auto directory = ftp.getWorkingDirectory();
        if (directory.isOk())
        {
            writeln("Working directory: ", directory.getDirectory());
        }

        auto listing = ftp.getDirectoryListing();

        if(listing.isOk())
        {
            const(string[]) list = listing.getFilenames();

            size_t length;

            if(list.length > 10)
            {
                length = 10;
            }
            else
            {
                length = list.length;
            }

            for(int i= 0; i < length; ++i)
            {
                writeln(list[i]);
            }
        }

        writeln();
    }
}

private extern(C):


struct sfFtpDirectoryResponse;
struct sfFtpListingResponse;
struct sfFtpResponse;
struct sfFtp;

//FTP Listing Response Functions

///Destroy a FTP listing response
void sfFtpListingResponse_destroy(sfFtpListingResponse* ftpListingResponse);


///Get the status code of a FTP listing response
Ftp.Response.Status sfFtpListingResponse_getStatus(const sfFtpListingResponse* ftpListingResponse);


///Get the full message contained in a FTP listing response
 const(char)* sfFtpListingResponse_getMessage(const(sfFtpListingResponse)* ftpListingResponse);


///Return the number of directory/file names contained in a FTP listing response
 size_t sfFtpListingResponse_getCount(const(sfFtpListingResponse)* ftpListingResponse);


///Return a directory/file name contained in a FTP listing response
 const(char)* sfFtpListingResponse_getName(const(sfFtpListingResponse)* ftpListingResponse, size_t index);



//FTP Directory Responce Functions

///Destroy a FTP directory response
 void sfFtpDirectoryResponse_destroy(sfFtpDirectoryResponse* ftpDirectoryResponse);


///Get the status code of a FTP directory response
Ftp.Response.Status sfFtpDirectoryResponse_getStatus(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);


///Get the full message contained in a FTP directory response
 const(char)* sfFtpDirectoryResponse_getMessage(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);


///Get the directory returned in a FTP directory response
 const(char)* sfFtpDirectoryResponse_getDirectory(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);



//FTP Responce functions

///Destroy a FTP response
 void sfFtpResponse_destroy(sfFtpResponse* ftpResponse);


///Get the status code of a FTP response
Ftp.Response.Status sfFtpResponse_getStatus(const(sfFtpResponse)* ftpResponse);


///Get the full message contained in a FTP response
const (char)* sfFtpResponse_getMessage(const sfFtpResponse* ftpResponse);


////FTP functions

///Create a new Ftp object
sfFtp* sfFtp_create();


///Destroy a Ftp object
void sfFtp_destroy(sfFtp* ftp);


///Connect to the specified FTP server
sfFtpResponse* sfFtp_connect(sfFtp* ftp, IpAddress* serverIP, ushort port, long timeout);


///Log in using an anonymous account
sfFtpResponse* sfFtp_loginAnonymous(sfFtp* ftp);


///Log in using a username and a password
sfFtpResponse* sfFtp_login(sfFtp* ftp, const(char)* userName, size_t userNameLength, const(char)* password, size_t passwordLength);


///Close the connection with the server
sfFtpResponse* sfFtp_disconnect(sfFtp* ftp);


///Send a null command to keep the connection alive
sfFtpResponse* sfFtp_keepAlive(sfFtp* ftp);


///Get the current working directory
sfFtpDirectoryResponse* sfFtp_getWorkingDirectory(sfFtp* ftp);


///Get the contents of the given directory
sfFtpListingResponse* sfFtp_getDirectoryListing(sfFtp* ftp, const(char)* directory, size_t length);


///Change the current working directory
sfFtpResponse* sfFtp_changeDirectory(sfFtp* ftp, const(char)* directory, size_t length);


///Go to the parent directory of the current one
sfFtpResponse* sfFtp_parentDirectory(sfFtp* ftp);


///Create a new directory
sfFtpResponse* sfFtp_createDirectory(sfFtp* ftp, const(char)* name, size_t length);


///Remove an existing directory
sfFtpResponse* sfFtp_deleteDirectory(sfFtp* ftp, const(char)* name, size_t length);


///Rename an existing file
sfFtpResponse* sfFtp_renameFile(sfFtp* ftp, const(char)* file, size_t fileLength, const(char)* newName, size_t newNameLength);


///Remove an existing file
sfFtpResponse* sfFtp_deleteFile(sfFtp* ftp, const(char)* name, size_t length);


///Download a file from a FTP server
sfFtpResponse* sfFtp_download(sfFtp* ftp, const(char)* distantFile, size_t distantFileLength, const(char)* destPath, size_t destPathLength, int mode);


///Upload a file to a FTP server
sfFtpResponse* sfFtp_upload(sfFtp* ftp, const(char)* localFile, size_t localFileLength, const(char)* destPath, size_t destPathLength, int mode);

///Send a command to a FTP server
sfFtpResponse* sfFtp_sendCommand(sfFtp* ftp, const(char)* command, size_t commandLength, const(char)* parameter, size_t parameterLength);