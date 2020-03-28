from hashlib import md5, sha1, sha256
import blockchain
import argparse
import sys
import os

def dc3dd_parser(dc3dd_arguments:list):
    """
    Parse the arguments sent to the dc3dd command
    dc3dd_arguments: the list of the arguments sent to the dc3dd command
    """
    
    input_file_name = None
    output_file_name = None
    for arg in dc3dd_arguments:
        if arg.startswith("if="):
            input_file_name = arg[3:]
        elif arg.startswith("of="):
            output_file_name = arg[3:]
        else:
            pass
    
    return input_file_name, output_file_name

def hash(filename):
    assert os.path.isfile(filename), Exception(f"{filename} does not exist. Please enter a valid file")
    hashes = md5(), sha1(), sha256()
    chunksize = max(4096, max(h.block_size for h in hashes))
    with open(filename, "rb") as f:
        while True:
            chunk = data = f.read(chunksize)
            if not chunk:
                break
            for h in hashes:
                h.update(chunk)
    return hashes



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='From the wrapper to the blockchain')
    parser.add_argument('-c', "--command", required=True, nargs='+',
                        help='the command to parse')
    parser.add_argument('-b', "--blockchain", nargs=1, action="store",
                        help='provide the name of the configuration file for the blockchain usage')
    
    args = parser.parse_args()
    # Determine which parser to use
    if args.command[0] == "dc3dd":
        input_file, output_file = dc3dd_parser(args.command)
    else:
        print("Tool not supported...")
        sys.exit(0)
    
    md5, sha1, sha256 = hash(output_file)

    bc_writer = blockchain.BlockChainWriter(args.blockchain[0])
    bc_writer.Set_hash(md5.hexdigest(), sha1.hexdigest(), sha256.hexdigest())
    bc_writer.Add_info("Block created from the python wrapper of dc3dd")
    bc_writer.Write_to_blockChain(output_file)
    
