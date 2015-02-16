#-------------------------------------------------------------------------------
# Copyright (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
# All rights reserved.
# 
# XEOS Software License - Version 1.0 - December 21, 2012
# 
# Permission is hereby granted, free of charge, to any person or organisation
# obtaining a copy of the software and accompanying documentation covered by
# this license (the "Software") to deal in the Software, with or without
# modification, without restriction, including without limitation the rights
# to use, execute, display, copy, reproduce, transmit, publish, distribute,
# modify, merge, prepare derivative works of the Software, and to permit
# third-parties to whom the Software is furnished to do so, all subject to the
# following conditions:
# 
#       1.  Redistributions of source code, in whole or in part, must retain the
#           above copyright notice and this entire statement, including the
#           above license grant, this restriction and the following disclaimer.
# 
#       2.  Redistributions in binary form must reproduce the above copyright
#           notice and this entire statement, including the above license grant,
#           this restriction and the following disclaimer in the documentation
#           and/or other materials provided with the distribution, unless the
#           Software is distributed by the copyright owner as a library.
#           A "library" means a collection of software functions and/or data
#           prepared so as to be conveniently linked with application programs
#           (which use some of those functions and data) to form executables.
# 
#       3.  The Software, or any substancial portion of the Software shall not
#           be combined, included, derived, or linked (statically or
#           dynamically) with software or libraries licensed under the terms
#           of any GNU software license, including, but not limited to, the GNU
#           General Public License (GNU/GPL) or the GNU Lesser General Public
#           License (GNU/LGPL).
# 
#       4.  All advertising materials mentioning features or use of this
#           software must display an acknowledgement stating that the product
#           includes software developed by the copyright owner.
# 
#       5.  Neither the name of the copyright owner nor the names of its
#           contributors may be used to endorse or promote products derived from
#           this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT OWNER AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, TITLE AND NON-INFRINGEMENT ARE DISCLAIMED.
# 
# IN NO EVENT SHALL THE COPYRIGHT OWNER, CONTRIBUTORS OR ANYONE DISTRIBUTING
# THE SOFTWARE BE LIABLE FOR ANY CLAIM, DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN ACTION OF CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#-------------------------------------------------------------------------------

# $Id$

#-------------------------------------------------------------------------------
# General
#-------------------------------------------------------------------------------

# Architecture to build
ARCHS := i386 x86_64

# File extensions
EXT_C      := .c
EXT_ASM    := .s
EXT_H      := .h
EXT_O      := .o
EXT_O_PIC  := .o-pic

#-------------------------------------------------------------------------------
# Paths & directories
#-------------------------------------------------------------------------------

# Project directories
DIR_SRC   := source/
DIR_INC   := include/
DIR_BUILD := build/
DIR_DEPS  := deps/

# Toolchain paths
PATH_TOOLCHAIN      := /usr/local/xeos-build/
PATH_TOOLCHAIN_YASM := $(PATH_TOOLCHAIN)yasm/
PATH_TOOLCHAIN_LLVM := $(PATH_TOOLCHAIN)llvm/

# GIT URL for dependancies
GIT_URL := https://github.com/macmade/%.git

#-------------------------------------------------------------------------------
# Software
#-------------------------------------------------------------------------------

# Assembler
AS            := $(PATH_TOOLCHAIN_YASM)bin/yasm
AS_i386       := $(AS)
AS_x86_64     := $(AS)
AS_PIC_i386   := $(AS)
AS_PIC_x86_64 := $(AS)

# Arguments for the assembler
ARGS_AS_i386       := -f elf
ARGS_AS_x86_64     := -f elf64
ARGS_AS_PIC_i386   := $(ARGS_AS_i386)
ARGS_AS_PIC_x86_64 := $(ARGS_AS_x86_64)

# C compiler
CC            := $(PATH_TOOLCHAIN_LLVM)bin/clang
CC_i386       := $(CC)
CC_x86_64     := $(CC)
CC_PIC_i386   := $(CC)
CC_PIC_x86_64 := $(CC)

# Arguments for the C compiler
ARGS_CC_WARN          := -Weverything -Werror
ARGS_CC_STD           := -std=c99
ARGS_CC_CONST         := -D __XEOS__ -D _POSIX_C_SOURCE=200809L -U __FreeBSD__ -U __FreeBSD_kernel__
ARGS_CC_INC           := -I $(DIR_INC)
ARGS_CC_MISC          := -Os -fno-strict-aliasing -nostdlib -nostdinc -fno-builtin -fblocks
ARGS_CC_PROFILE       := -finstrument-functions
ARGS_CC_PIC           := -fPIC
ARGS_CC_TARGET_i386   := -march=i386 -target i386-elf-freebsd
ARGS_CC_TARGET_x86_64 := -march=x86-64 -target x86_64-elf-freebsd
ARGS_CC_i386          := $(ARGS_CC_TARGET_32) $(ARGS_CC_MISC) $(ARGS_CC_INC) $(ARGS_CC_STD) $(ARGS_CC_WARN) $(ARGS_CC_CONST) $(ARGS_CC_PROFILE)
ARGS_CC_x86_64        := $(ARGS_CC_TARGET_64) $(ARGS_CC_MISC) $(ARGS_CC_INC) $(ARGS_CC_STD) $(ARGS_CC_WARN) $(ARGS_CC_CONST) $(ARGS_CC_PROFILE)
ARGS_CC_PIC_i386      := $(ARGS_CC_i386) $(ARGS_CC_PIC)
ARGS_CC_PIC_x86_64    := $(ARGS_CC_x86_64) $(ARGS_CC_PIC)

#-------------------------------------------------------------------------------
# Display
#-------------------------------------------------------------------------------

# Colors for the terminal output
COLOR_NONE   := "\x1b[0m"
COLOR_GRAY   := "\x1b[30;01m"
COLOR_RED    := "\x1b[31;01m"
COLOR_GREEN  := "\x1b[32;01m"
COLOR_YELLOW := "\x1b[33;01m"
COLOR_BLUE   := "\x1b[34;01m"
COLOR_PURPLE := "\x1b[35;01m"
COLOR_CYAN   := "\x1b[36;01m"

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# 
# Prints a message to the standard output
# 
# @param    The message
# 
PRINT = @echo $(foreach _P,$(PROMPT),"[ "$(COLOR_GREEN)$(_P)$(COLOR_NONE)" ]>")" *** "$(1)

# 
# Prints an architecture related message to the standard output
# 
# @param    The architecture
# @param    The message
# 
PRINT_ARCH = $(call PRINT,$(2) [ $(COLOR_RED)$(1)$(COLOR_NONE) ])

# 
# Prints an architecture related message about a file to the standard output
# 
# @param    The architecture
# @param    The message
# @param    The file
# 
PRINT_FILE = $(call PRINT_ARCH,$(1),$(2)): $(3)

# 
# Gets all C files from a specific directory
# 
# @param    The directory
# 
XEOS_FUNC_C_FILES = $(foreach _F,$(wildcard $(1)*$(EXT_C)),$(_F))

# 
# Gets all ASM files from a specific directory
# 
# @param    The directory
# 
XEOS_FUNC_S_FILES = $(foreach _F,$(wildcard $(1)*$(EXT_S)),$(_F))

# 
# Gets all object files to build from C sources
# 
# @param    The architecture
# @param    The object file extension
# 
XEOS_FUNC_C_OBJ = $(foreach _F,$(filter %$(EXT_C),$(FILES)),$(patsubst %,$(DIR_BUILD)$(1)/%$(2),$(subst /,.,$(patsubst $(DIR_SRC)%,%,$(_F)))))

# 
# Gets all object files to build from ASM sources
# 
# @param    The architecture
# @param    The object file extension
# 
XEOS_FUNC_S_OBJ = $(foreach _F,$(filter %$(1)$(EXT_ASM),$(FILES)),$(patsubst %,$(DIR_BUILD)$(1)/%$(2),$(subst /,.,$(patsubst $(DIR_SRC)%,%,$(_F)))))

# 
# Gets all object files to build
# 
# @param    The architecture
# @param    The object file extension
# 
XEOS_FUNC_OBJ = $(call XEOS_FUNC_C_OBJ,$(1),$(2)) $(call XEOS_FUNC_S_OBJ,$(1),$(2))
